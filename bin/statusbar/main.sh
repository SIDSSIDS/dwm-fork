#!/usr/bin/env bash

generated_output_top() {
    DIR=$(dirname "$0")
    conky -c ${DIR}/config_top.lua
}

generated_output_bottom() {
    DIR=$(dirname "$0")
    conky -c ${DIR}/config_bottom.lua
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# parameters

width=900
height=21
xpos=-$width
ypos=0
fgcolor="#ffffff"
#bgcolor="#ff0000"
bgcolor="#222222"
font="Liberation Mono:pixelsize=14:antialias=true:autohint=true"

parameters="  -h $height" 
parameters+=" -ta r -bg $bgcolor -fg $fgcolor"
parameters+=" -title-name dzentop"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

# remove all dzen2 instance
pkill dzen2

# execute dzen
generated_output_top    | dzen2 $parameters -x $xpos -w $width -y 0 -fn "$font" &
generated_output_bottom | dzen2 $parameters -x 0 -y -21 -fn "$font" &




