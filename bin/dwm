#!/bin/bash

#set us keyboard
setxbmap us
#set keyboard repeat rate
xset r rate 250 60
#load X apps configs like urxvt
xrdb -merge ~/.Xresources
#set resolution to 1440x900
xrandr --output default --mode 1680x1050 &
#make sure Java uses the right toolkit
wmname LG3D &
#start vmware-tools
vmware-user

#set the status bar at the top
while true; do
  xsetroot -name "$(date +"%F %R" )"
  sleep 1m
done &

exec /home/developer/dev/apps/dwm-6.0/dwm
