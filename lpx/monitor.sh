xrandr | grep -q "^HDMI1 connected" && (xrandr --output HDMI1 --auto && xrandr --output eDP1 --off) || (xrandr --output eDP1 --mode 1920x1080 --scale 2x2 --panning 3840x2160)
