-- Jack Casey

-- | A module for working with uncertainty calculations, in accordance to the
--   rules we use in Physics.

module UncertaintyCalc where

data Measurement = PoM Rational Rational

instance Show Measurement where
    show m = let (PoM a b) = roundMeasurement m in 
        "(" ++ show (fromRational a) ++ " +- "
            ++ show (fromRational b) ++ ")"

instance Num Measurement where
    (PoM v1 u1) + (PoM v2 u2) = PoM (v1 + v2) (rootSquares [u1, u2])
    (PoM v1 u1) * (PoM v2 u2) = PoM 
        (v1 * v2)
        ((v1 * v2) * rootSquares [u1 / v1, u2 / v2])
    abs (PoM v1 u1)           = PoM (abs v1) u1
    signum (PoM v1 _)         = PoM (signum v1) 0
    fromInteger i             = PoM (toRational i) 0
    negate (PoM v1 u1)        = PoM (negate v1) u1

instance Fractional Measurement where
    fromRational r = PoM r 0
    (PoM v1 u1) / (PoM v2 u2) = PoM 
        (v1 / v2)
        ((v1 / v2) * rootSquares[u1 / v1, u2 / v2])
                           
pow :: (Real a, Floating a) => Measurement -> a -> Measurement
pow (PoM v1 u1) p = PoM (toRational (fromRational v1 ** p)) $
    toRational (fromRational v1 ** p) * toRational p * (u1 / v1) 
                       
getTPrime :: Measurement -> Measurement -> Double
getTPrime (PoM v1 u1) (PoM v2 u2) = abs . fromRational $ 
    (v1 - v2) / rootSquares [u1, u2]

roundUncertainty :: Rational -> Rational
roundUncertainty d
    | d == 0          = 0
    | d < 1           = 0.1 * roundUncertainty (d * 10.0)
    | d > 10          = 10 * roundUncertainty (d * 0.1)
    | d >= 1 && d < 3 = (0.1 *) $ fromIntegral $ round (10.0 * d)
    | otherwise       = fromIntegral $ round d

roundValue :: Rational -> Rational -> Rational
roundValue val roundedErr
    | roundedErr == 0  = val
    | roundedErr >= 10 && roundedErr < 30 || roundedErr < 10 && roundedErr >= 3
                       = fromIntegral $ round val
    | roundedErr >= 30 = 10  * roundValue (0.1 * val) (0.1 * roundedErr)
    | otherwise        = 0.1 * roundValue (10 * val)   (10 * roundedErr)

roundMeasurement :: Measurement -> Measurement
roundMeasurement (PoM val err)
    | val >= 0  = PoM (roundValue val (roundUncertainty err)) (roundUncertainty err)
    | otherwise = PoM (-1) 0.0 * roundMeasurement (PoM (-1 * val) err)

rootSquares :: [Rational] -> Rational
rootSquares = toRational . (** 0.5) . fromRational . foldr ((+) . (^2)) 0.0

helpMessage :: String
helpMessage = "Format a Measurement like this: (2.0 `PoM` 0.05)\n" 
    ++ "You can add, substract, multiply and divide as normal.\n" 
    ++ "You can raise a Measurement to an Integer power by calling: "
        ++ "pow (Measurement) n\n" 
    ++ "You can properly round your Measurement by calling roundMeasurent.\n" 
    ++ "Note that proper rounding occurs after calculations automatically.\n"
    ++ "Determine the t' value between two measurements by calling: "
        ++ "getTPrime m1 m2\n"
    ++ "(Remember that less than 1 is agreement and greater than "
        ++ "3 is disagreement).\n"

help :: IO ()
help = putStrLn helpMessage
