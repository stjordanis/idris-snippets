module StreamFusion


data TypeT : Type where
  UnitT : TypeT
  IntT : TypeT
  BoolT : TypeT
  ArrayT : TypeT -> TypeT
  VarT : Type -> TypeT -> TypeT
  ArrowT : TypeT -> TypeT -> TypeT

Show TypeT where
  show UnitT = "unit"
  show IntT = "int"
  show BoolT = "bool"
  show (ArrayT typ) = show typ ++ " []"
  show (VarT _ typ) = show typ ++ " ref"
  show (ArrowT arg res) = "(" ++ show arg ++ " -> " ++ show res ++ ")"


interface Symantics (rep : TypeT -> Type) where
  defaultof : rep a
  int : Int -> rep IntT
  bool : Bool -> rep BoolT
  (==) : rep IntT -> rep IntT -> rep BoolT
  (>) : rep IntT -> rep IntT -> rep BoolT
  (<) : rep IntT -> rep IntT -> rep BoolT
  (&&) : rep BoolT -> rep BoolT -> rep BoolT
  (||) : rep BoolT -> rep BoolT -> rep BoolT
  (+) : rep IntT -> rep IntT -> rep IntT
  (*) : rep IntT -> rep IntT -> rep IntT
  ite : rep BoolT -> rep a -> rep a -> rep a
  it : rep BoolT -> rep UnitT -> rep UnitT
  deref : rep (VarT s a) -> rep a
  assign : rep a -> rep (VarT s a) -> rep UnitT
  newVar : rep a -> ({s : Type} -> rep (VarT s a) -> rep b) -> rep b
  index : rep IntT -> rep (ArrayT a) -> rep a
  length : rep (ArrayT a) -> rep IntT
  while : rep BoolT -> rep UnitT -> rep UnitT
  seq : rep a -> rep b -> rep b
  seqs : List (rep UnitT) -> rep UnitT
  lam : (rep a -> rep b) -> rep (ArrowT a b)
  app : rep (ArrowT a b) -> rep a -> rep b

data Code : TypeT -> Type where
  C : (Int -> String) -> Code a


Symantics Code where
  defaultof {a = UnitT} = C (\_ => "()")
  defaultof {a = IntT} = C (\_ => "0")
  defaultof {a = BoolT} = C (\_ => "false")
  defaultof {a = (ArrayT x)} = C (\_ => "null")
  defaultof {a = (VarT x y)} = C (\_ => "null")
  defaultof {a = (ArrowT x y)} = C (\_ => "null")
  int x = C (\_ => show x)
  bool x = C (\_ => if x then "true" else "false")
  (==) (C l) (C r) = C (\v => "( " ++ l v ++ " = " ++ r v ++ " )")
  (>) (C l) (C r) = C (\v => "( " ++ l v ++ " > " ++ r v ++ " )")
  (<) (C l) (C r) = C (\v => "( " ++ l v ++ " < " ++ r v ++ " )")
  (&&) (C l) (C r) = C (\v => "( " ++ l v ++ " && " ++ r v ++ " )")
  (||) (C l) (C r) = C (\v => "( " ++ l v ++ " || " ++ r v ++ " )")
  (+) (C l) (C r) = C (\v => "( " ++ l v ++ " + " ++ r v ++ " )")
  (*) (C l) (C r) = C (\v => "( " ++ l v ++ " * " ++ r v ++ " )")
  ite (C b) (C l) (C r) = C (\v => "(if " ++ b v ++ " then " ++ l v ++ " else " ++ r v ++ ")")
  it (C b) (C t) = C (\v => "(if " ++ b v ++ " then " ++ t v ++ ")")
  deref (C x) = C (\v => "!" ++ x v)
  assign (C val) (C var) = C (\v => var v ++ " := " ++ val v)
  newVar {a} (C s) f = C (\v => let x = "x" ++ show v in
                                let (C c) = f $ the (Code (VarT () a)) (C (\_ => x)) in
                                "let " ++ x ++ " = ref " ++ s v ++ " in " ++ c (v + 1))
  index (C i) (C arr) = C (\v => arr v ++ ".[" ++ i v ++ "]")
  length (C arr) = C (\v => arr v ++ ".Length")
  while (C p) (C b) = C (\v => "(while " ++ p v ++ " do " ++ b v ++ ")")
  seq (C fs) (C sn) = C (\v => "(" ++ fs v ++ "; " ++ sn v ++ ")")
  seqs steps = foldr seq defaultof steps
  lam {a} f = C (\v => let x = "x" ++ show v in
                   let (C g) = f (C (\_ => x)) in
                   "(fun (" ++ x ++ " : " ++ show a ++ ") -> " ++ g (v + 1) ++ ")")
  app (C f) (C g) = C (\v => "(" ++ f v ++ " " ++ g v ++ ")")


data Stream : (rep : TypeT -> Type) -> (a : TypeT) -> Type where
  SC : ((s -> rep UnitT) -> rep UnitT) ->
       (s -> rep BoolT) ->
       (s -> (rep a -> rep UnitT) -> rep UnitT) ->
       (s -> rep UnitT) -> (s -> rep UnitT) -> Stream rep a


ofArray : Symantics rep => rep (ArrayT a) -> Stream rep a
ofArray arr = SC (init arr) next current step reset
  where
    init : rep (ArrayT a) -> ((rep (ArrayT a), DPair Type (\s => rep (VarT s IntT))) -> rep UnitT) -> rep UnitT
    init arr k = newVar (int 0) (\v => k (arr, (_ ** v)))
    next : (rep (ArrayT a), DPair Type (\s => rep (VarT s IntT))) -> rep BoolT
    next (arr, (_ ** v)) = deref v < length arr
    current : (rep (ArrayT a), DPair Type (\s => rep (VarT s IntT))) -> (rep a -> rep UnitT) -> rep UnitT
    current (arr, (_ ** v)) k = k (index (deref v) arr)
    step : (rep (ArrayT a), DPair Type (\s => rep (VarT s IntT))) -> rep UnitT
    step (arr, (_ ** v)) = assign (deref v + (int 1)) v
    reset : (rep (ArrayT a), DPair Type (\s => rep (VarT s IntT))) -> rep UnitT
    reset (arr, (_ ** v)) = assign (int 0) v


fold : Symantics rep => (rep a -> rep r -> rep r) -> rep r -> Stream rep a -> rep r
fold f seed stream = newVar seed (\acc => seq (fold' (\x => assign (f x (deref acc)) acc) stream) (deref acc))
  where
    fold' : (rep a -> rep UnitT) -> Stream rep a -> rep UnitT
    fold' k (SC init next current step reset) = init (\s => while (next s) (seq (current s k) (step s)))

count : Symantics rep => Stream rep a -> rep IntT
count = fold (\x, acc => acc + (int 1)) (int 0)

sum : Symantics rep => Stream rep IntT -> rep IntT
sum = fold (\x, acc => x + acc) (int 0)

map : (rep a -> rep b) -> Stream rep a -> Stream rep b
map f (SC init next current step reset) = SC init next (\s, k => current s (\x => k (f x))) step reset

StreamC : (TypeT -> Type) -> Type -> TypeT -> Type
StreamC rep s a = (s, ((s -> rep UnitT) -> rep UnitT), (s -> rep BoolT),
                      (s -> (rep a -> rep UnitT) -> rep UnitT),
                      (s -> rep UnitT), (s -> rep UnitT))

flatMap : Symantics rep => (rep a -> Stream rep b) -> Stream rep a -> Stream rep b
flatMap f (SC init' next' current' step' reset') = SC (init f init') (next next') (current current') (step step') (reset reset')
  where
    init : (rep a -> Stream rep b) -> ((s -> rep UnitT) -> rep UnitT) -> ((s, DPair Type (\s' => rep (VarT s' BoolT)), DPair Type (\s' => rep (VarT s' a)), DPair Type (\s' => StreamC rep s' b)) -> rep UnitT) -> rep UnitT
    init f inita k = newVar (bool True) (\b => newVar defaultof (\v => let (SC initb nextb currentb stepb resetb) = f (deref v) in inita (\st => initb (\st' => k (st, (_ ** b), (_ ** v), (_ ** (st', initb, nextb, currentb, stepb, resetb)))))))
    next : (s -> rep BoolT) -> (s, DPair Type (\s' => rep (VarT s' BoolT)), DPair Type (\s' => rep (VarT s' a)), DPair Type (\s' => StreamC rep s' b)) -> rep BoolT
    next nexta (st, _, _, _) = nexta st
    current : (s -> (rep a -> rep UnitT) -> rep UnitT) -> (s, DPair Type (\s' => rep (VarT s' BoolT)), DPair Type (\s' => rep (VarT s' a)), DPair Type (\s' => StreamC rep s' b)) -> (rep b -> rep UnitT) -> rep UnitT
    current currenta (st, (_ ** b), (_ ** v), (_ ** (st', initb, nextb, currentb, stepb, resetb))) k =
      seqs [it (deref b) (seqs [currenta st (\a => assign a v), assign (bool False) b]),
            ite (nextb st') (seqs [currentb st' k, stepb st'])
                            (seqs [resetb st', assign (bool True) b])]
    step : (s -> rep UnitT) -> (s, DPair Type (\s' => rep (VarT s' BoolT)), DPair Type (\s' => rep (VarT s' a)), DPair Type (\s' => StreamC rep s' b)) -> rep UnitT
    step stepa (st, (_ ** b), _, _) = it (deref b) (stepa st)
    reset : (s -> rep UnitT) -> (s, DPair Type (\s' => rep (VarT s' BoolT)), DPair Type (\s' => rep (VarT s' a)), DPair Type (\s' => StreamC rep s' b)) -> rep UnitT
    reset reseta (st, _, _, _) = reseta st


example0 : Symantics rep => rep (ArrayT IntT) -> rep IntT
example0 = sum . map (\x => x * (int 2)) . ofArray

example1 : Symantics rep => rep (ArrayT IntT) -> rep IntT
example1 arr = (sum . flatMap (\x => nested arr x) . ofArray) arr
  where
    nested : rep (ArrayT IntT) -> rep IntT -> Stream rep IntT
    nested arr x = (map (\x' => x * x') . ofArray) arr

test : Code (ArrowT (ArrayT IntT) IntT)
test = lam example1

code : String
code = let (C c) = test in c 0