#!/bin/bash

setxbmap us
xset r rate 250 120
xrdb -merge ~/.Xresources
xrandr --output default --mode 1440x900 &
wmname LG3D &

while true; do
  xsetroot -name "$(date +"%F %R" )"
  sleep 1m
done &

exec /home/developer/dev/apps/dwm-6.0/dwm
