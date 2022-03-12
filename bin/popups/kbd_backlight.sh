#!/bin/bash

# xbacklight -ctrl asus::kbd_backlight -get
# xbacklight -get

source $(dirname $0)/../colors

level=$(xbacklight -ctrl asus::kbd_backlight -get)

FontAwesome="^fn(FontAwesome6Free-32:style=Solid)"
DefFont="^fn()"

kbd_sym=""

if [[ "$level" == 0 ]]
then
    sym_col=$colRed500
else
    sym_col=$colYellow500
fi

message="^fg($sym_col)$FontAwesome$kbd_sym^fg($colGreen500)$DefFont  $level%"

$(dirname $0)/popup.sh "$message" 150 50 middle middle 1
