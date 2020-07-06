module SMTLib

import Data.Vect
import System

%access public export

data NumTyp = IntT | RealT

data TypeT : Type where
  BoolT : TypeT
  NumT : NumTyp -> TypeT
  BitVecT : Nat -> TypeT

Show TypeT where
  show BoolT = "Bool"
  show (NumT IntT) = "Int"
  show (NumT RealT) = "Real"
  show (BitVecT n) = "(_ BitVec " ++ show n ++ ")"


data Expr : TypeT -> Type where
  VarExpr : String -> (t : TypeT) -> Expr t
  BoolExpr : Bool -> Expr BoolT
  BvExpr : Int -> (n : Nat) -> Expr (BitVecT n)
  BvAddExpr : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
  BvSubExpr : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
  BvMulExpr : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
  BvUDivExpr : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
  BvURemExpr : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
  BvSDivExpr : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
  BvSModExpr : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
  BvShLExpr :  Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
  BvLShRExpr :  Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
  BvAShRExpr :  Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
  BvNegExpr : Expr (BitVecT n) -> Expr (BitVecT n)
  BvAndExpr : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
  BvOrExpr : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
  BvXorExpr : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
  BvNotExpr : Expr (BitVecT n) -> Expr (BitVecT n)
  BvULeExpr : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr BoolT
  BvULtExpr : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr BoolT
  BvUGeExpr : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr BoolT
  BvUGtExpr : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr BoolT
  BvSLeExpr : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr BoolT
  BvSLtExpr : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr BoolT
  BvSGeExpr : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr BoolT
  BvSGtExpr : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr BoolT
  IntExpr : Int -> Expr (NumT IntT)
  RealExpr : Double -> Expr (NumT RealT)
  AddExpr : Vect n (Expr (NumT a)) -> Expr (NumT a)
  MinusExpr : Vect n (Expr (NumT a)) -> Expr (NumT a)
  MulExpr : Vect n (Expr (NumT a)) -> Expr (NumT a)
  EqualExpr : Expr a -> Expr a -> Expr BoolT
  DistinctExpr : Vect n (Expr a) -> Expr BoolT
  LessExpr : Expr (NumT a) -> Expr (NumT a) -> Expr BoolT
  LessOrEqualExpr : Expr (NumT a) -> Expr (NumT a) -> Expr BoolT
  GreaterExpr : Expr (NumT a) -> Expr (NumT a) -> Expr BoolT
  GreaterOrEqualExpr : Expr (NumT a) -> Expr (NumT a) -> Expr BoolT
  AndExpr : Vect n (Expr BoolT) -> Expr BoolT
  OrExpr : Vect n (Expr BoolT) -> Expr BoolT
  NotExpr : Expr BoolT -> Expr BoolT
  ImpExpr : Expr BoolT -> Expr BoolT -> Expr BoolT
  IteExpr : Expr BoolT -> Expr a -> Expr a -> Expr a



bool : Bool -> Expr BoolT
bool x = BoolExpr x

bv : Int -> (n : Nat) -> Expr (BitVecT n)
bv x n = BvExpr x n

int : Int -> Expr (NumT IntT)
int x = IntExpr x

real : Double -> Expr (NumT RealT)
real x = RealExpr x

bvadd : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
bvadd l r = BvAddExpr l r

bvsub : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
bvsub l r = BvSubExpr l r

bvmul : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
bvmul l r = BvMulExpr l r

bvsdiv : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
bvsdiv l r = BvSDivExpr l r

bvsmod : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
bvsmod l r = BvSModExpr l r

bvudiv : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
bvudiv l r = BvUDivExpr l r

bvurem : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
bvurem l r = BvURemExpr l r

bvshl : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
bvshl l r = BvShLExpr l r

bvlshr : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
bvlshr l r = BvLShRExpr l r

bvashr : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
bvashr l r = BvAShRExpr l r

bvneg : Expr (BitVecT n) -> Expr (BitVecT n)
bvneg x = BvNegExpr x

bvand : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
bvand l r = BvAndExpr l r

bvor : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
bvor l r = BvOrExpr l r

bvxor : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr (BitVecT n)
bvxor l r = BvXorExpr l r

bvnot : Expr (BitVecT n) -> Expr (BitVecT n)
bvnot x = BvNotExpr x

bvule : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr BoolT
bvule l r = BvULeExpr l r

bvult : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr BoolT
bvult l r = BvULtExpr l r

bvuge : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr BoolT
bvuge l r = BvUGeExpr l r

bvugt : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr BoolT
bvugt l r = BvUGtExpr l r

bvsle : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr BoolT
bvsle l r = BvSLeExpr l r

bvslt : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr BoolT
bvslt l r = BvSLtExpr l r

bvsge : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr BoolT
bvsge l r = BvSGeExpr l r

bvsgt : Expr (BitVecT n) -> Expr (BitVecT n) -> Expr BoolT
bvsgt l r = BvSGtExpr l r

(+) : Expr (NumT a) -> Expr (NumT a) -> Expr (NumT a)
(+) l r = AddExpr [l, r]

(-) : Expr (NumT a) -> Expr (NumT a) -> Expr (NumT a)
(-) l r = MinusExpr [l, r]

add : Vect n (Expr (NumT a)) -> Expr (NumT a)
add xs = AddExpr xs

(*) : Expr (NumT a) -> Expr (NumT a) -> Expr (NumT a)
(*) l r = MulExpr [l, r]

mul : Vect n (Expr (NumT a)) -> Expr (NumT a)
mul xs = MulExpr xs

(==) : Expr a -> Expr a -> Expr BoolT
(==) l r = EqualExpr l r

distinct : Vect n (Expr a) -> Expr BoolT
distinct xs = DistinctExpr xs

(<) : Expr (NumT a) -> Expr (NumT a) -> Expr BoolT
(<) l r = LessExpr l r

(<=) : Expr (NumT a) -> Expr (NumT a) -> Expr BoolT
(<=) l r = LessOrEqualExpr l r

(>) : Expr (NumT a) -> Expr (NumT a) -> Expr BoolT
(>) l r = GreaterExpr l r

(>=) : Expr (NumT a) -> Expr (NumT a) -> Expr BoolT
(>=) l r = GreaterOrEqualExpr l r


(&&) : Expr BoolT -> Expr BoolT -> Expr BoolT
(&&) l r = AndExpr [l, r]

(||) : Expr BoolT -> Expr BoolT -> Expr BoolT
(||) l r = OrExpr [l, r]

and : Vect n (Expr BoolT) -> Expr BoolT
and xs = AndExpr xs

or : Vect n (Expr BoolT) -> Expr BoolT
or xs = OrExpr xs

not : Expr BoolT -> Expr BoolT
not x = NotExpr x

imp : Expr BoolT -> Expr BoolT -> Expr BoolT
imp l r = ImpExpr l r

ite' : Expr BoolT -> Expr BoolT -> Expr BoolT -> Expr BoolT
ite' p l r = and [imp p l, imp (not p) r]

ite : Expr BoolT -> Expr a -> Expr a -> Expr a
ite p l r = IteExpr p l r

data Cmd : Type -> Type where
  DeclareVarCmd : String -> (t : TypeT) -> Cmd (Expr t)
  DeclareVarsCmd : Traversable f => f String -> (t : TypeT) -> Cmd (f (Expr t))
  AssertCmd : Expr BoolT -> Cmd ()
  CheckSatCmd : Cmd ()
  GetModelCmd : Cmd ()
  SetOptionCmd : String -> Cmd ()
  SetLogicCmd : String -> Cmd ()

data Smt : Type -> Type where
  Pure : a -> Smt a
  Bind : Cmd a -> (a -> Smt b) -> Smt b

pure : a -> Smt a
pure x = Pure x

(>>=) : Smt a -> (a -> Smt b) -> Smt b
(>>=) (Pure x) f = f x
(>>=) (Bind cmd g) f = Bind cmd (\x => g x >>= f)

end : Smt ()
end = Pure ()

declareVar : String -> (t : TypeT) -> Smt (Expr t)
declareVar v t = Bind (DeclareVarCmd v t) pure

declareVars : Traversable f => f String -> (t : TypeT) -> Smt (f (Expr t))
declareVars vs t = Bind (DeclareVarsCmd vs t) pure

assert : Expr BoolT -> Smt ()
assert e = Bind (AssertCmd e) pure

checkSat : Smt ()
checkSat = Bind CheckSatCmd pure

getModel : Smt ()
getModel = Bind GetModelCmd pure

setOption : String -> Smt ()
setOption s = Bind (SetOptionCmd s) pure

setLogic : String -> Smt ()
setLogic s = Bind (SetLogicCmd s) pure



compileExpr : Expr t -> String
compileExpr (VarExpr x t) = x
compileExpr (BoolExpr x) = if x then "true" else "false"
compileExpr (BvExpr x n) = "(_ bv" ++ show x ++ " " ++ show n ++ ")"
compileExpr (IntExpr x) = show x
compileExpr (RealExpr x) = show x
compileExpr (BvAddExpr l r) = "(bvadd " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (BvMulExpr l r) = "(bvmul " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (BvSDivExpr l r) = "(bvsdiv " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (BvSModExpr l r) = "(bvsmod " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (BvUDivExpr l r) = "(bvudiv " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (BvURemExpr l r) = "(bvurem " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (BvShLExpr l r) = "(bvshl " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (BvLShRExpr l r) = "(bvlshr " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (BvAShRExpr l r) = "(bvashr " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (BvNegExpr x) = "(bvneg " ++ compileExpr x ++ ")"
compileExpr (BvAndExpr l r) = "(bvand " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (BvSubExpr l r) = "(bvsub " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (BvOrExpr l r) = "(bvor " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (BvXorExpr l r) = "(bvxor " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (BvNotExpr x) = "(bvnot " ++ compileExpr x ++ ")"
compileExpr (BvULeExpr l r) = "(bvule " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (BvULtExpr l r) = "(bvult " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (BvUGeExpr l r) = "(bvuge " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (BvUGtExpr l r) = "(bvugt " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (BvSLeExpr l r) = "(bvsle " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (BvSLtExpr l r) = "(bvslt " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (BvSGeExpr l r) = "(bvsge " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (BvSGtExpr l r) = "(bvsgt " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (AddExpr xs) = "(+ " ++ (unlines . toList . map compileExpr) xs ++ ")"
compileExpr (MinusExpr xs) = "(- " ++ (unlines . toList . map compileExpr) xs ++ ")"
compileExpr (MulExpr xs) = "(* " ++ (unlines . toList . map compileExpr) xs ++ ")"
compileExpr (EqualExpr l r) = "(= " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (DistinctExpr xs) = "(distinct " ++ (unlines . toList . map compileExpr) xs ++ ")"
compileExpr (LessExpr l r) = "(< " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (LessOrEqualExpr l r) = "(<= " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (GreaterExpr l r) = "(> " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (GreaterOrEqualExpr l r) = "(>= " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (AndExpr xs) = "(and " ++ (unlines . toList . map compileExpr) xs ++ ")"
compileExpr (OrExpr xs) = "(or " ++ (unlines . toList . map compileExpr) xs ++ ")"
compileExpr (NotExpr x) = "(not " ++ compileExpr x ++ ")"
compileExpr (ImpExpr l r) = "(=> " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"
compileExpr (IteExpr p l r) = "(if " ++ compileExpr p ++ " " ++ compileExpr l ++ " " ++ compileExpr r ++ ")"

compileCmd : Cmd a -> (a, String)
compileCmd (DeclareVarCmd x t) = (VarExpr x t, "(declare-const " ++ x ++ " " ++ show t ++ ")")
compileCmd (DeclareVarsCmd xs t) = (map (\x => VarExpr x t) xs,
                                    (unlines . toList . map (\x => "(declare-const " ++ x ++ " " ++ show t ++ ")")) xs)
compileCmd (AssertCmd e) = ((), "(assert " ++ compileExpr e ++ ")")
compileCmd CheckSatCmd = ((), "(check-sat)")
compileCmd GetModelCmd = ((), "(get-model)")
compileCmd (SetOptionCmd s) = ((), "(set-option " ++ s ++ ")")
compileCmd (SetLogicCmd s) = ((), "(set-logic " ++ s ++ ")")

compile : Smt () -> String
compile smt = unlines $ compile' smt
  where
    compile' : Smt () -> List String
    compile' (Pure ()) = [""]
    compile' (Bind cmd f) = let (a, s) = compileCmd cmd in
                           let s' = compile' $ f a in
                           s :: s'

example0 : Expr BoolT
example0 = (bool True) && (bool True)

example1 : Expr BoolT
example1 = (bv 1 8) == (bv 1 8)

example2 : Smt ()
example2 = checkSat

example3 : Smt ()
example3 = do x <- declareVar "x" BoolT
              y <- declareVar "y" BoolT
              assert $ x && y
              checkSat
              getModel
              end

example4 : Smt ()
example4 = do [x, y] <- declareVars {f = Vect 2} ["x", "y"] BoolT
              assert $ not (x && y) == (not x || not y)
              checkSat
              getModel
              end

exec : String -> String -> IO Int
exec input output = system $ "z3 -smt2 " ++ input ++ " > " ++ output

data Result = Sat | UnSat | Unknown

Show Result where
  show Sat = "sat"
  show UnSat = "unsat"
  show Unknown = "unknown"

Model : Type
Model = List (String, String)

parseResult : List String -> Maybe (Result, List String)
parseResult ("sat" :: "(model " :: xs) = Just (Sat, xs)
parseResult ("unsat" :: xs) = Just (UnSat, xs)
parseResult ("unknown" :: xs) = Just (Unknown, xs)
parseResult _ = Nothing

parseVar : List Char -> Maybe (List Char)
parseVar ('(' :: 'd' :: 'e' :: 'f' :: 'i' :: 'n' :: 'e' :: '-' :: 'f' :: 'u' :: 'n' :: ' ' :: xs) = parseVar' xs
  where
    parseVar' : List Char -> Maybe (List Char)
    parseVar' (' ' :: xs) = Just []
    parseVar' (x :: xs) = do xs <- parseVar' xs
                             Just (x :: xs)
    parseVar' _ = Nothing
parseVar _ = Nothing


parseValue' : List Char -> Maybe (List Char)
parseValue' [] = Just []
parseValue' (')' :: _) = Just []
parseValue' (' ' :: _) = Just []
parseValue' [_] = Nothing
parseValue' (x :: xs) = do xs <- parseValue' xs
                           Just (x :: xs)

parseValue : List Char -> Maybe (List Char)
parseValue ('(' :: '_' :: ' ' :: 'b' :: 'v' :: xs) = parseValue' xs
parseValue xs = parseValue' xs


parseModel : List String -> Maybe (Model, List String)
parseModel [")"] = Just ([], [])
parseModel (x :: y :: xs) = do (model, xs) <- parseModel xs
                               var <- parseVar (unpack (ltrim x))
                               value <- parseValue (unpack (ltrim y))
                               Just ((pack var, pack value) :: model, xs)
parseModel _ = Nothing



sat : Smt () -> IO (Maybe (Result, Model))
sat smt = do _ <- writeFile "input.smt2" $ compile smt
             putStrLn "z3 solving"
             _ <- exec "input.smt2" "output.smt2"
             r <- readFile "output.smt2"
             case r of
               Left err => do printLn err; pure Nothing
               Right str => let r = parseResult $ filter (\line => not $ line == "") $ lines str in
                            case r of
                              Nothing => do putStrLn "Error parsing result"; pure Nothing
                              Just (Sat, xs) => let r = parseModel xs in
                                                case r of
                                                  Nothing => do putStrLn "Error parsing model"; pure Nothing
                                                  Just (model, xs) => pure $ Just (Sat, model)
                              Just (UnSat, xs) => pure $ Just (UnSat, [])
                              Just (Unknown, xs) => pure $ Just (Unknown, [])

print : Smt () -> IO ()
print smt = putStrLn $ compile smt
