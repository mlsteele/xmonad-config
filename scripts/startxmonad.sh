#!/bin/bash
# setxkbmap -option ctrl:nocaps & # Make Caps Lock a Control Key
# setxkbmap -option altwin:swap_lalt_lwin & # Swap Left Super with Left Alt
# syndaemon -i 1 -k -d & # Disable mouse while typing
synclient TapAndDragGesture=0 & # Disable double tap-drag gesture
synclient HorizTwoFingerScroll=1 & # Enable horizontal touchpad scrolling
synclient AccelFactor=0.04 & # Speed up touchpad
synclient MaxSpeed=3.0 & # Speed up touchpad
stalonetray & # App tray
# xscreensaver -nosplash & # Screensaver
# xautolock -detectsleep -time 30 -locker "xscreensaver-command -lock ; sudo pm-suspend" & # Sleep after inactivity
xautolock -detectsleep -time 30 -locker "gnome-screensaver-command --lock; sudo pm-suspend" & # Sleep after inactivity
nm-applet & # Network Management applet
# wicd-gtk -t & # Network Management applet
xcompmgr -c & # Composition for transparent windows
# nemo --no-default-window
# nautilus --no-default-window &
# dropbox start &
exec /home/miles/.cabal/bin/xmonad
