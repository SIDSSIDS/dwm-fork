#!/bin/bash

state=$($(dirname $0)/../touchpad state)

FontAwesome="^fn(FontAwesome5Free-74:style=Solid)"

colGreen500="#4caf50"
colRed500="#f44336"

on_sym=""
off_sym=""

case "$state" in
    "0" ) message="^fg($colRed500)$FontAwesome$off_sym" ;;
    "1" ) message="^fg($colGreen500)$FontAwesome$on_sym" ;;
esac

$(dirname $0)/popup.sh "$message" 100 100 middle middle 1
