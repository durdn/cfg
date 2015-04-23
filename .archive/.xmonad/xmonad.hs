--
-- xmonad config for xmonad-0.9
-- Nicola Paolucci

import XMonad
import Data.Monoid
import System.Exit
 
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- personal imports
-- layouts
import XMonad.Layout.Decoration
import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.NoBorders
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Maximize
-- my tiny modification to the Circle layout
-- import XMonad.Layout.SmallerCircle
-- hooks
import XMonad.Hooks.ManageDocks
-- prompts
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise
-- actions
import XMonad.Actions.SwapWorkspaces
import XMonad.Actions.GridSelect
-- disabled
-- import XMonad.Layout.Circle
-- import qualified XMonad.Layout.Magnifier as Mag
-- end personal imports

modifiers x = maximize $ avoidStruts $ smartBorders x
myLayout = modifiers (decoTCM ||| 
            -- decoCircle |||
            Full |||
            decoTiled )
            -- Mirror decoTiled ||| 
            -- ThreeCol 1 (3/100) (1/2) ||| 
  where
    decoTiled = noFrillsDeco shrinkText myTheme tiled
    -- decoCircle = noFrillsDeco shrinkText myTheme SmallerCircle
    decoTCM = noFrillsDeco shrinkText myTheme (ThreeColMid 1 (3/100) (1/2))
    tiled   = Tall nmaster delta ratio
    nmaster = 1
    ratio   = 1/2
    delta   = 3/100
 
myTerminal      = "gnome-terminal"
 
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
myBorderWidth   = 2
myModMask       = mod1Mask
myNumlockMask   = mod2Mask
 
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#0000ff"
 
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm,               xK_p        ), spawn "exe=`dmenu_path | dmenu -nb black -nf white -sb white -sf black -fn lucidasanstypewriter-bold-24` && eval \"exec $exe\"")
    , ((modm,               xK_b        ), sendMessage ToggleStruts)
    , ((modm,               xK_g        ), goToSelected defaultGSConfig)
    , ((modm,               xK_s        ), spawnSelected defaultGSConfig ["gnome-terminal","firefox","google-chrome","gvim"])
    , ((modm.|.controlMask, xK_x        ), runOrRaisePrompt defaultXPConfig) 
    , ((modm,               xK_backslash), withFocused (sendMessage . maximizeRestore))
    --, ((modm .|. shiftMask, xK_m        ), updateLayout (W.currentTag W.current) (Full (W.view, 0)))
    ]
    ++
    [((modm .|. m, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    [((modm .|. m, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++
    [((modm .|. controlMask, k), windows $ swapWithCurrent i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 ..]]

 
 
myTheme = defaultTheme { activeColor         = "#484848"
                       , inactiveColor       = "gray"
                       , activeBorderColor   = "gray"
                       , inactiveBorderColor = "#484848"
                       , activeTextColor     = "white"
                       , inactiveTextColor   = "black"
                       , decoHeight          = 14
                       }


myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

newManageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig
 
myEventHook = mempty
myLogHook = return ()
myStartupHook = return ()
 
main = xmonad defaults
defaults = defaultConfig {
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
        keys = \c -> myKeys c `M.union` keys defaultConfig c,
        layoutHook         = myLayout,
        manageHook         = newManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
