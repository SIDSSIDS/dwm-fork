#!/bin/bash

source $(dirname $0)/../colors

level=$(pamixer --get-volume)
muted=$(pamixer --get-mute)

FontAwesome="^fn(FontAwesome5Free-32:style=Solid)"
DefFont="^fn()"

mute_sym=""
vol_sym=""

case "$muted" in
    "true"  ) message="^fg($colRed500)$FontAwesome$mute_sym$DefFont"           ;;
    "false" ) message="^fg($colYellow500)$FontAwesome$vol_sym^fg($colGreen500)$DefFont  $level%" ;;
esac

$(dirname $0)/popup.sh "$message" 150 50 middle middle 1
