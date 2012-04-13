while xsetroot -name "`date \"+%d %b [%a] %H:%M\"` `uptime | sed 's/.*,//'`"
do
  sleep 20
done &

wmname LG3D &
xrandr --output default --mode 1440x900 &

/home/developer/dev/apps/dwm-6.0/dwm
