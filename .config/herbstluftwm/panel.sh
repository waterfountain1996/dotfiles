#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

BAR='mainbar'

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload "$BAR" &
  done
else
  polybar --reload "$BAR" &
fi

echo "Bars launched..."
