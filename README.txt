# UncertaintyCalculator
This is the calculator I use for propagating uncertainty and performing t' tests.

What you need: 
    This file, on your computer.  Git is scary at first, but you can also just copy paste code.
    Haskell on your computer, and access to ghci.  Googling Haskell gets you to a download page fast.
    Enough command line knowledge to get to wherever this directory is.
    Ghci, the Haskell interpretter.  Really, this is the calculator, and my code just defines the data
        type it uses.

What the code does: (if you get confused, run the help command)
    This code defines a data type, Measurement, that reflects a double value and its uncertainty.
    Values of this data type can be constructed with the PoM constructor.
    You can +, -, *, / values of these types as expected.  You cannot do math with values of other
        types though, you will need to convert them to Measurements.  (eg 1.0 `PoM` 0.0000)
    You can raise Measurements to a power with pow.  The power cannot be a measurement in this case,
        it must be a normal number.
    You can perform t' tests, with getTPrime, in order to see if two values agree.
    Also: Whenever the calculator does math with measurements, it propagates uncertainty! Thats the 
        whole point!
    Additionally, it mostly takes care of rounding too.  Whenever it shows a measurement, it rounds, 
        but it keeps track or way more information in the background, so don't be alarmed.
    Finally, you can do normal haskell stuff with this in ghci.  Maybe you write a function that works
        on normal values, chances are it works on these too!  Storing variables is also super handy, 
        just be careful with shadowing old variables with new ones.

Example of use:
    :l UncertaintyCalc.hs         -- Load the module into ghci
    a = PoM 1.0  0.1              -- The leading 0 is necessary
    bee = 2.2454 `PoM` 0.04       -- The `` makes PoM infix (which I think looks nicer).  Also you are
                                  --     not limited to single letter variables.
    a + bee                       -- Outputs what you expect!
    f x = pow x 2                 -- You can write functions in ghci.  f here takes an x, and returns 
                                  --     x squared
    f a                           -- Call your function on a
    pow a 0.5                     -- This is equivalent to square roots
    getTPrime a bee               -- Returns the t' between these values.
    sum [a, bee, PoM 1.23 0.1233] -- Haskell's type classes mean that any function that operates on Nums
                                  --     works with my type.  I didn't even need to define this!
    numerator = a + bee           -- I can define variables in terms of variables to build up a complex 
                                  --     computation
    denom = a * (PoM 2.0 0.00)    
    numerator / denom             -- Note though that if I change a, I will have to rerun the last three 
                                  --     calls, since they use the old value of a.  Be careful.
    :q                            -- End the ghci session.  Note that your work will be lost (though there
                                  --     is some memory so that you can access old calls).
            
