#!/bin/sh
## Unfortunatly GNOME fails to set up my favorite resolution on my DELL XPS 13.
## Using this script on startup forces the xrandr to set those parameters
xrandr --output eDP-1 --mode 1920x1080 --scale 1x1
