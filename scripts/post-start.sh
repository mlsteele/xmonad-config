# setxkbmap -option ctrl:nocaps # make caps lock a control key
# setxkbmap -option altwin:swap_lalt_lwin # swap super and alt
# sleep 2 && xmodmap ~/.xmonad/xmodmap
pkill syndaemon ; syndaemon -i 1 -k -d # disable mouse while typing
pkill nemo ; nemo --no-default-window # render desktop
