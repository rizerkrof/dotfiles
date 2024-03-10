module Layouts where

import XMonad
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.WindowNavigation
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

import XMonad.Actions.MouseResize

import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks, ToggleStruts(..))

import Constants

--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
setWindowsSpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
setWindowsSpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
setSpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
setSpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
-- limitWindows n sets maximum number of windows displayed for layout.
-- mySpacing n sets the gap size around the windows.
tall     = renamed [Replace "tall"]
           $ limitWindows 5
           $ smartBorders
           $ windowNavigation
           -- $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ setWindowsSpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ smartBorders Simplest
           $ windowNavigation
           -- $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ Full
floats   = renamed [Replace "floats"]
           $ smartBorders
           $ simplestFloat
grid     = renamed [Replace "grid"]
           $ limitWindows 9
           $ smartBorders
           $ windowNavigation
           -- $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ setWindowsSpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)


layoutHook = avoidStruts
               $ mouseResize
               $ windowArrange
               $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
  where
    myDefaultLayout = withBorder configBorderWidth tall
                                          -- ||| noBorders monocle
                                          -- ||| floats
                                          -- ||| noBorders tabs
                                           ||| grid
                                          -- ||| spirals
                                          -- ||| threeCol
                                          -- ||| threeRow
                                          -- ||| tallAccordion
                                          -- ||| wideAccordion


