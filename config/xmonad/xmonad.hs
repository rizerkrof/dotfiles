import XMonad

import XMonad.Hooks.EwmhDesktops

import XMonad.Util.NamedActions

import Keys (keybindings, showKeybindings)
import Layouts (configLayoutHook)
import Constants


main :: IO () 
main = do
  terminal <- configEnvTerminal
  xmonad $ addDescrKeys' ((mod4Mask .|. shiftMask, xK_h), showKeybindings) keybindings $ ewmh $ def
    { modMask = configModMask
    , layoutHook = configLayoutHook
    , terminal = terminal 
    }
