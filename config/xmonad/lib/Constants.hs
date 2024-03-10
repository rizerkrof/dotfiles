module Constants where
import XMonad
import System.Environment (getEnv)

-- set modkey to super instead of alt
configModMask :: KeyMask
configModMask = mod4Mask

-- set terminal to the default nix config term
configEnvTerminal :: IO String
configEnvTerminal = getEnv "TERMINAL"

configBorderWidth :: Dimension
configBorderWidth = 2

