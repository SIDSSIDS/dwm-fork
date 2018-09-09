#!/bin/bash

# xbacklight -ctrl asus::kbd_backlight -get
# xbacklight -get

level=$(xbacklight -get)

FontAwesome="^fn(FontAwesome5Free-32:style=Solid)"
DefFont="^fn()"

colGreen500="#4caf50"
colRed500="#f44336"
colYellow500="#ffeb3b"

light_sym=""

if [[ "$level" == 10 ]]
then
    sym_col=$colRed500
else
    sym_col=$colYellow500
fi

message="^fg($sym_col)$FontAwesome$light_sym^fg($colGreen500)$DefFont  $level%"

$(dirname $0)/popup.sh "$message" 150 50 middle middle 1
