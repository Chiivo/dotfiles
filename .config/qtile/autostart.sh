#!/bin/sh
xrandr --output DP-2 --mode 1920x1080 --rate 144.00 --output HDMI-0 --mode 1920x1080 --rate 60.00 &
nitrogen --restore &
picom --experimental-backends &
udiskie &
discord &
blueman-applet &
