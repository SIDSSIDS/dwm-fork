#!/usr/bin/env bash

source $(dirname $0)/../colors

generated_output() {
    DIR=$(dirname "$0")
    conky -c ${DIR}/config_clock.lua
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# parameters

titleName="dzen-clock"
font="Liberation Mono-14:style=Bold"
width=153
lines=2
xpos=-$width
ypos=21
# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# MAIN

# kill running dzen-clock instances
pkill -f "dzen2 -title-name $titleName"

# execute dzen
generated_output | dzen2 -title-name "$titleName" \
                         -fn "$font" \
                         -fg "$colWhite" \
                         -bg "#0087AF" \
                         -p \
                         -u \
                         -x "$xpos" \
                         -y "$ypos" \
                         -w "$width" \
                         -l "$((lines-1))" \
                         -sa 'r' \
                         -ta 'r' \
                         -e 'onstart=uncollapse;button1=exit;button3=exit' &




