import XMonad
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Prompt
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.Minimize
import XMonad.Hooks.ScreenCorners
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ICCCMFocus
import XMonad.Layout.Reflect
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spiral
import XMonad.Layout.Minimize
import XMonad.Layout.BoringWindows
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
--import XMonad.Layout.LimitWindows
import XMonad.Layout.WorkspaceDir
import XMonad.Actions.Volume
import XMonad.Actions.CycleWS
import XMonad.Actions.CycleWSByN
import XMonad.Actions.GridSelect
import XMonad.Actions.WorkspaceNames
import XMonad.Actions.WindowGo
--import XMonad.Actions.CycleRecentWS
import XMonad.Actions.UpdatePointer
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import Graphics.X11.ExtraTypes.XF86
import System.IO

myModMask = mod4Mask

myBorderWidth = 2
myNormalBorderColor  = "#000"
myFocusedBorderColor = "#f00"

myWorkspaces = map show [1..12]

myNumpadKeys = [
    xK_KP_Home, xK_KP_Up,    xK_KP_Prior, -- 7 8 9
    xK_KP_Left, xK_KP_Begin, xK_KP_Right, -- 4 5 6
    xK_KP_End,  xK_KP_Down,  xK_KP_Next,  -- 1 2 3
    xK_KP_Insert, xK_KP_Delete] -- 0 dot

myNumpadKeysOrdered = [
    xK_KP_End,  xK_KP_Down,  xK_KP_Next,  -- 1 2 3
    xK_KP_Left, xK_KP_Begin, xK_KP_Right, -- 4 5 6
    xK_KP_Home, xK_KP_Up,    xK_KP_Prior, -- 7 8 9
    xK_KP_Insert, xK_KP_Delete] -- 0 dot

myStartupHook :: X()
myStartupHook = do
    spawn "notify-send XMonad \"XMonad restarted.\""
    spawn "/home/miles/.xmonad/scripts/post-start.sh"
    --return ()
    --addScreenCorner SCUpperRight nextWS
    --addScreenCorner SCUpperLeft  prevWS

--myEventHook = minimizeEventHook
--myEventHook e = do screenCornerEventHook e
myEventHook e = do
    minimizeEventHook e
    screenCornerEventHook e

myManagementHooks :: [ManageHook]
myManagementHooks = [
    isFullscreen --> (doF W.focusDown <+> doFullFloat),
    resource =? "desktop_window" --> doIgnore,
    className =? "stalonetray" --> doIgnore,
    className =? "Galculator" --> doFloat
    ]

myScratchpads = [
    -- NS name cmd query hook
    NS "htop" "xterm -e htop" (title =? "htop") (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3))
    ]

myLayout = workspaceDir "~" $ avoidStruts $ boringWindows $ smartBorders $ minimize $ mkToggle (single FULL) $
    (reflectHoriz tiled) ||| myTabbed ||| (reflectHoriz threecols)
    where
    -- Tall (windows in master) (ratio of screen for master) (%screen resize increment)
    tiled = Tall 1 (3/100) (1/2)
    mySpiral = spiral (6/7)
    threecols = ThreeCol 1 (3/100) (-1/3)
    myTabbed = tabbed shrinkText defaultTheme {
        activeColor = "#0cf",
        activeBorderColor = "#0cf",
        inactiveColor = "#555",
        inactiveBorderColor = "#777"
    }

myXMobarLogger handle = workspaceNamesPP xmobarPP {
    ppOutput = hPutStrLn handle,
    ppCurrent = xmobarColor "#0cf" "" . wrap "(" ")",
    ppTitle = xmobarColor "green" "" . shorten 50,
    ppSep = "    "
} >>= dynamicLogWithPP >> updatePointer (Relative 0.2 0.2)

myKeys = [
    --
    -- Applications
    --
    -- launch and focus terminal
    ((myModMask .|. shiftMask, xK_Return), spawn "terminator"),
    ((myModMask .|. shiftMask, xK_n), spawn "terminator"),
    ((myModMask, xK_n), runOrRaise "terminator" (className =? "Terminator")),

    -- launch and focus browser
    --((myModMask .|. shiftMask, xK_o), spawn "chromium-browser"),
    --((myModMask, xK_o), runOrRaise "chromium-browser" (className =? "Chromium-browser")),
    ((myModMask .|. shiftMask, xK_o), spawn "google-chrome"),
    ((myModMask, xK_o), runOrRaise "google-chrome" (className =? "Google-chrome")),

    -- launch and focus editor
    -- ((myModMask .|. shiftMask, xK_i), spawn "subl -n"),
    -- ((myModMask, xK_i), runOrRaise "subl -n" (className =? "Sublime_text")),
    ((myModMask .|. shiftMask, xK_i), spawn "gvim"),
    ((myModMask, xK_i), runOrRaise "givm" (className =? "Gvim")),

    -- launch any application
    ((myModMask, xK_p), spawn "~/.xmonad/scripts/launchbar.sh"),
    ((myModMask .|. shiftMask, xK_p), spawn "gmrun"),

    -- change working directory
    ((myModMask .|. shiftMask, xK_x), changeDir defaultXPConfig),

    --
    -- Navigation
    --
    -- close window
    ((myModMask, xK_w), kill),

    -- switch workspaces
    -- (see end of bindings for numpad controls)
    ((myModMask, xK_Left), prevWS),
    ((myModMask, xK_Right), nextWS),
    ((myModMask, xK_Down), cycleByN (-3) ),
    ((myModMask, xK_Up), cycleByN 3 ),
    --((myModMask, xK_Tab), cycleRecentWS [xK_Super_L] xK_Tab xK_grave),

    -- switch windows
    ((myModMask, xK_Tab), focusDown),
    ((myModMask, xK_j), focusDown),
    ((myModMask, xK_k), focusUp),

    -- fullscreen
    ((myModMask, xK_f), sendMessage $ Toggle FULL),

    -- minimize
    ((myModMask, xK_m), withFocused minimizeWindow),
    ((myModMask .|. shiftMask, xK_m), sendMessage RestoreNextMinimizedWin),

    -- grid select
    ((myModMask, xK_g), gridselectWorkspace defaultGSConfig W.greedyView),

    --
    -- Media Keys
    --
    -- change volume
    ((0, xF86XK_AudioLowerVolume), spawn "~/.xmonad/scripts/volume.rb down q && ~/.xmonad/scripts/volume.rb unmute q"),
    ((0, xF86XK_AudioRaiseVolume), spawn "~/.xmonad/scripts/volume.rb up q && ~/.xmonad/scripts/volume.rb unmute q"),
    ((0, xF86XK_AudioMute), spawn "~/.xmonad/scripts/volume.rb toggle q"),
    --((0, xF86XK_AudioLowerVolume), spawn "~/.xmonad/scripts/unmute.sh && amixer set Master 2-"),
    --((0, xF86XK_AudioRaiseVolume), spawn "~/.xmonad/scripts/unmute.sh && amixer set Master 2+"),
    --((0, xF86XK_AudioMute), spawn "~/.xmonad/scripts/togglemute.sh"),
    --((0, xF86XK_AudioLowerVolume), spawn "~/.xmonad/scripts/unmute.sh ; pactl -- set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo -5%"),
    --((0, xF86XK_AudioRaiseVolume), spawn "~/.xmonad/scripts/unmute.sh ; pactl -- set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo +5%"),
    --((0, xF86XK_AudioMute), spawn "~/.xmonad/scripts/unmute.sh ; pactl -- set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo 0%"),
    --((0, xF86XK_AudioLowerVolume), lowerVolume 3 >> return ()),
    --((0, xF86XK_AudioRaiseVolume), raiseVolume 3 >> return ()),
    --((0, xF86XK_AudioMute), toggleMute >> return ())
    --((0, xF86XK_AudioPlay), spawn "~/.xmonad/scripts/pithos-playpause.sh"),
    --((0, xF86XK_AudioNext), spawn "~/.xmonad/scripts/pithos-skip.sh")

    --
    -- Misc
    --
    -- rename workspace
    ((myModMask .|. shiftMask, xK_r), renameWorkspace defaultXPConfig),

    -- monitor layout
    ((myModMask, xK_bracketleft), spawn "~/.screenlayout/little.sh"),
    ((myModMask, xK_bracketright), spawn "~/.screenlayout/big.sh"),
    ((myModMask, xK_backslash), spawn "~/.screenlayout/both.sh"),

    -- lock and sleep
    ((myModMask, xK_z), spawn "gnome-screensaver-command --lock"),
    ((myModMask .|. shiftMask, xK_z), spawn "gnome-screensaver-command --lock && sudo pm-suspend"),

    -- monitor floating
    ((myModMask .|. controlMask, xK_h), namedScratchpadAction myScratchpads "htop"),

    -- demolition man
    ((0, xK_KP_Add), spawn "ogg123 /home/miles/Documents/demoman/demoman-trim-fade-nameless.ogg"),

    --
    -- Meta
    --
    -- restart xmonad
    ((myModMask, xK_q), restart "/home/miles/.cabal/bin/xmonad" True)
    --((myModMask, xK_q), spawn "/home/miles/.cabal/bin/xmonad --recompile; /home/miles/.cabal/bin/xmonad --restart")
    --((myModMask, xK_q), spawn "xmonad --recompile; xmonad --restart") -- default restart behavior
    --((myModMask, xK_q), spawn "/home/miles/.cabal/bin/xmonad --recompile && /home/miles/.cabal/bin/xmonad --restart"),
    --((myModMask, xK_q), spawn "xmessage restarting... && which xmonad && { xmonad --recompile && xmonad --restart } || xmessage xmonad not in path"),

    ] ++
    -- Navigation with numpad
    -- mod-[keypad_n], Switch to workspace n
    -- mod-shift-[keypad_n], Move window to workspace n
    [((m .|. myModMask, k), windows $ f i)
        | (i, k) <- zip myWorkspaces myNumpadKeysOrdered
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

myMouseBindings (XConfig {XMonad.modMask = myModMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((myModMask .|. shiftMask, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((myModMask .|. shiftMask, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((myModMask .|. shiftMask, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

main = do
    xmproc <- spawnPipe "/home/miles/.cabal/bin/xmobar ~/.xmonad/xmobar.hs"
    xmonad $ defaultConfig {
            modMask = myModMask,
            workspaces = myWorkspaces,
            mouseBindings = myMouseBindings,
            borderWidth = myBorderWidth,
            normalBorderColor  = myNormalBorderColor,
            focusedBorderColor = myFocusedBorderColor,
            startupHook = myStartupHook,
            manageHook = manageDocks <+> manageHook defaultConfig <+> (namedScratchpadManageHook myScratchpads) <+> composeAll myManagementHooks,
            layoutHook = myLayout,
            handleEventHook = myEventHook,
            logHook = (fadeInactiveLogHook 0.95) <+> (myXMobarLogger xmproc) <+> takeTopFocus
        } `additionalKeys` myKeys
