#!/bin/bash

level=$(pamixer --get-volume)
muted=$(pamixer --get-mute)

FontAwesome="^fn(FontAwesome5Free-32:style=Solid)"
DefFont="^fn()"

colGreen500="#4caf50"
colRed500="#f44336"
colYellow500="#ffeb3b"

mute_sym=""
vol_sym=""

case "$muted" in
    "true"  ) message="^fg($colRed500)$FontAwesome$mute_sym$DefFont"           ;;
    "false" ) message="^fg($colYellow500)$FontAwesome$vol_sym^fg($colGreen500)$DefFont  $level%" ;;
esac

$(dirname $0)/popup.sh "$message" 150 50 middle middle 1
