import XMonad
import XMonad.Util.SpawnOnce
import XMonad.Util.WorkspaceCompare (getSortByXineramaRule)

import XMonad.Config.Desktop (desktopConfig
                             ,desktopLayoutModifiers)

import XMonad.Layout.ResizableTile
import XMonad.Layout.NoBorders (noBorders,smartBorders, hasBorder)
import XMonad.Layout.Gaps (gaps,GapMessage (..))
import XMonad.Layout.Spacing (spacingRaw
                             ,Border(..)
                             ,toggleScreenSpacingEnabled
                             ,toggleWindowSpacingEnabled
                             ,toggleSmartSpacing)
import qualified XMonad.Layout.Fullscreen as FS
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL))
import XMonad.Layout.MultiToggle (Toggle (..))

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops ( ewmh
                                 , ewmhDesktopsEventHook
                                 , ewmhDesktopsLogHook
                                 , ewmhDesktopsLogHookCustom
                                 , fullscreenEventHook )
import XMonad.Hooks.ManageDocks ( Direction2D(..)
                                , ToggleStruts (..)
                                , avoidStruts
                                , docks
                                , docksEventHook )
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, isInProperty)
import XMonad.Hooks.FadeInactive ( fadeInactiveLogHook )
import qualified XMonad.Hooks.FadeWindows as Fade

import XMonad.Actions.GridSelect (goToSelected
                                 ,bringSelected
                                 ,defaultGSConfig)
import XMonad.Actions.FloatKeys
import XMonad.Actions.NoBorders (toggleBorder)

import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

import qualified Graphics.X11.ExtraTypes.XF86 as XF86

import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map as Map
import XMonad.Config.Kde (kde4Config)

----------------------------------------------------------------------------------------------------
-- * Configuration Variables

-- | The preferred terminal program
myTerminal      = "alacritty"

-- | Whether focus follows the mouse pointer.
myFocusFollowsMouse = True
-- | Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses = False

-- | Width of the window border in pixels.
myBorderWidth   = 1
-- | Border colors for unfocused windows, respectively.
myNormalBorderColor  = "#dddddd" -- gray
-- | Border colors for focused windows, respectively.
myFocusedBorderColor = "#00ffff"
-- purple "#bf00ff", lightblue #00ffff, darkblue "#0000ff"

-- | The default number of workspaces (virtual screens) and their names.
--   By default we use numeric strings, but any string may be used as a
--   workspace name. The number of workspaces is determined by the length
--   of this list.
--
--   A tagging example:
--
--   > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

----------------------------------------------------------------------------------------------------
-- * Main

main = xmonad kde4Config
    { -- hooks
      manageHook      = manageHook kde4Config <+> myManageHook
    , logHook         = ewmhDesktopsLogHook <+> Fade.fadeWindowsLogHook myFadeHook
    , handleEventHook = myEventHook <+> handleEventHook desktopConfig
    , startupHook     = myStartupHook <+> startupHook kde4Config
    , layoutHook      = desktopLayoutModifiers $ smartBorders myLayout
      -- keys / mouse
    , modMask = mod4Mask -- use the Windows button as mod
    , keys = myKeys <+> keys kde4Config
    , focusFollowsMouse  = myFocusFollowsMouse
    , clickJustFocuses   = myClickJustFocuses
      -- miscellaneous configuration
    , workspaces = myWorkspaces
    , normalBorderColor  = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    , borderWidth        = myBorderWidth
    , terminal           = myTerminal
    }

----------------------------------------------------------------------------------------------------
-- * Hooks

-- | Windows Management Hook
--   Provides a means to manage window settings by properties like className, title, etc (use the xprop command
--   line utitlity to "discover" a windows properties). For opacity settings see @myFadeHook@
myManageHook = composeAll . concat $
    [
      [ className   =? "krunner" --> doIgnore >> doFloat ]
    , [(className   =? "plasmashell" <&&> checkSkipTaskbar) --> doIgnore <+> hasBorder False ]
    , [ className   =? c --> doFloat           | c <- myFloats]
    , [ title       =? t --> doFloat           | t <- myOtherFloats]
    , [ resource  =? "kdesktop"       --> doIgnore ]
    , [ resource  =? "desktop_window" --> doIgnore ]
    , [ isFullscreen  --> doFloat ]
    , [ FS.fullscreenManageHook  ]
    -- , [ className   =? c --> doF (W.shift "2") | c <- webApps]
    -- , [ className   =? c --> doF (W.shift "3") | c <- ircApps]
    ]
  where
    myFloats      = ["plasmashell"]
    myOtherFloats = ["alsamixer"]
    -- webApps       = ["Firefox-bin", "Opera"] -- open on desktop 2
    -- ircApps       = ["Ksirc"]                -- open on desktop 3
    checkSkipTaskbar :: Query Bool
    checkSkipTaskbar = isInProperty "_NET_WM_STATE" "_NET_WM_STATE_SKIP_TASKBAR"

-- | Fade Management Hook
--   Provides a means to manage window opacity
myFadeHook = composeAll [ Fade.opaque
                        , className =? "Alacritty"  --> Fade.transparency 0.1
                        , className =? "discord"
                          <&&> Fade.isUnfocused
                          <&&> fmap not isFullscreen --> Fade.transparency 0.1
                        , className =? "Emacs"
                          <&&> Fade.isUnfocused --> Fade.transparency 0.05
                        ]

-- | Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
myEventHook = fullscreenEventHook <+> Fade.fadeWindowsEventHook <+> ewmhDesktopsEventHook

-- | Startup Hook
--   Provides a hook to launch executables at startup
myStartupHook = do
  spawnOnce "startplasma-x11 &"
  -- spawnOnce "plasmawindow org.kde.plasma.systemtray"
  -- Not tested but the above should standalone run systemtray

-- | Layout Hook
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
myLayout = addSpaces $ addGaps $ tiled ||| tall ||| Full
  --tiled ||| Mirror tiled ||| Full
  where
     -- add spaces (configurable amount of space around windows)
     addSpaces = spacingRaw True (Border 0 5 5 5) True (Border 5 5 5 5) True
     -- add gaps (adds space/gaps along edges of screen)
     addGaps = gaps [(U,10),(R,10),(L,10),(D,10)]
     -- Two master panes, 1/10th resize increment, only show master
     -- panes by default. Unlike plain 'Tall', this also allows
     -- resizing the master panes, via the 'MirrorShrink' and
     -- 'MirrorExpand' messages
     -- need to import xmonad-contrib
     tall = ResizableTall 2 (1/10) 1 []
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

----------------------------------------------------------------------------------------------------
-- * Key bindings. Add, modify or remove key bindings here.

-- | Key bindings
--   All keybindings are configured here
myKeys conf@(XConfig {XMonad.modMask = modm}) = Map.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- -- launch rofi
    -- , ((modm,               xK_p     ), spawn "rofi -modi drun,ssh,window -show drun -show-icons -dpi $DPI")

    -- -- launch dmenu
    -- , ((modm .|. shiftMask, xK_p     ), spawn "dmenu_run")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    -- , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Toggles noborder/full
    , ((modm .|. shiftMask, xK_space ), sendMessage (Toggle NBFULL)
                                        >> sendMessage ToggleStruts
                                        >> toggleScreenSpacingEnabled
                                        >> toggleWindowSpacingEnabled
                                        >> sendMessage ToggleGaps)

    -- Toggles border
    , ((modm .|. shiftMask, xK_b), withFocused  toggleBorder)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    -- , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    -- , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))

    -- Resize windows using ResizableTall Layout
    , ((modm, xK_Left),  sendMessage MirrorExpand)
    , ((modm, xK_Up),    sendMessage MirrorExpand)
    , ((modm, xK_Right), sendMessage MirrorShrink)
    , ((modm, xK_Down),  sendMessage MirrorShrink)

    -- Resize floating windows
    -- , ((modm,               xK_d     ), withFocused (keysResizeWindow (-10,-10) (1,1)))
    -- , ((modm,               xK_s     ), withFocused (keysResizeWindow (10,10) (1,1)))
    -- , ((modm ,              xK_w     ), withFocused (keysResizeWindow (10,0) (1,1)))
    -- , ((modm .|. shiftMask, xK_w     ), withFocused (keysResizeWindow (-10,0) (1,1)))
    -- , ((modm ,              xK_e     ), withFocused (keysResizeWindow (0,10) (1,1)))
    -- , ((modm .|. shiftMask, xK_e     ), withFocused (keysResizeWindow (0,-10) (1,1)))

    -- Grid Select
    , ((modm, xK_g), goToSelected def)
    , ((modm .|. shiftMask, xK_g), bringSelected  def)
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_i, xK_o, xK_u] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

    -- ++
    -- -- adjust audio via keyboard and pulseaudio
    -- [((0,XF86.xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +1.5%")
    -- ,((0,XF86.xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -1.5%")
    -- ,((0,XF86.xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    -- ]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = Map.fromList

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), \w -> focus w >> mouseMoveWindow w
                                      >> windows W.shiftMaster)

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), \w -> focus w >> windows W.shiftMaster)

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), \w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster)

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]
