module Keys where

import XMonad
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.WithAll (killAll)
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)

import XMonad.Hooks.ManageDocks (ToggleStruts(..))

import XMonad.Util.EZConfig (mkNamedKeymap)
import XMonad.Util.NamedActions
import XMonad.Util.Run (spawnPipe)

import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

import Data.Char (toUpper)

keybindings :: XConfig l0 -> [((KeyMask, KeySym), NamedAction)]
keybindings c = 
  let subKeys str ks = subtitle' str : mkNamedKeymap c ks in
  subKeys "Xmonad Essentials"
  [ ("M-C-r", addName "Recompile XMonad"            $ spawn "xmonad --recompile")
  , ("M-S-r", addName "Restart XMonad"              $ spawn "xmonad --restart")
  , ("m-S-q", addName "Quit XMonad"                 $ io exitSuccess)
  , ("M-S-p", addName "Open applications"           $ spawn "rofi -show drun")
  , ("M-S-c", addName "Kill focused window"         $ kill1) -- Kill the currently focused client
  , ("M-S-a", addName "Kill all work space windows" $ killAll)
  ]

  ^++^ subKeys "Window navigation"
  [ ("M-j", addName "Move focus to next window"                $ windows W.focusDown)
  , ("M-k", addName "Move focus to prev window"                $ windows W.focusUp)
  , ("M-m", addName "Move focus to master window"              $ windows W.focusMaster)
  , ("M-S-j", addName "Swap focused window with next window"   $ windows W.swapDown)
  , ("M-S-k", addName "Swap focused window with prev window"   $ windows W.swapUp)
  , ("M-S-m", addName "Swap focused window with master window" $ windows W.swapMaster)
  , ("M-<Backspace>", addName "Move focused window to master"  $ promote)
  , ("M-S-,", addName "Rotate all windows except master"       $ rotSlavesDown)
  , ("M-S-.", addName "Rotate all windows current stack"       $ rotAllDown)
  ]

  ^++^ subKeys "Switch layout"
  [ ("M-<Tab>", addName "Switch to next layout"   $ sendMessage NextLayout)
  -- , ("M-<Space>", addName "Toggle noborders/full" $ sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)
  ]

subtitle' ::  String -> ((KeyMask, KeySym), NamedAction)
subtitle' x = ((0,0), NamedAction $ map toUpper
                      $ sep ++ "\n-- " ++ x ++ " --\n" ++ sep)
  where
    sep = replicate (6 + length x) '-'

showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = addName "Show Keybindings" $ io $ do
  let keybindingsText = unlines $ showKmSimple x
  _ <- spawnPipe $ "echo \"" ++ keybindingsText ++ "\" | rofi -dmenu -i -p \"XMonad keybindings\""
  return ()

