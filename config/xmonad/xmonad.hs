import XMonad

import XMonad.Hooks.EwmhDesktops

import Keys (keybindings, showKeybindings)
import Layouts (layoutHook)
import Constants


main :: IO () 
main = do
  terminal <- configEnvTerminal
  xmonad $ addDescrKeys' ((mod4Mask .|. shiftMask, xK_h), showKeybindings) keybindings $ ewmh $ def
    { modMask = configModMask
    , layoutHook = layoutHook
    , terminal = configEnvTerminal
    }
