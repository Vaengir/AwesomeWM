#!/bin/sh
xsetroot -solid black
xsetroot -cursor_name top_left_arrow
#bell volume 0
xset b 0
#screensaver off
xset s off
xmodmap $HOME/.Xmodmap
xrdb -load $HOME/.Xdefaults
ivman &
exec /usr/bin/awesome
