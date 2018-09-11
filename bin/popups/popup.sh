#!/bin/bash

source $(dirname $0)/../colors

message=$1
WIDTH=$2
HEIGHT=$3
x_align=$4
y_align=$5
timeout=${6:-0}

screenW=$(xdpyinfo | grep dimensions | egrep -o "[0-9]+x[0-9]+ pixels" | egrep -o "[0-9]+x[0-9]+" | sed "s/x.*//")
screenH=$(xdpyinfo | grep dimensions | egrep -o "[0-9]+x[0-9]+ pixels" | egrep -o "[0-9]+x[0-9]+" | sed "s/.*x//")


case "$x_align" in
    "left"   ) xpos=0                                           ;;
    "middle" ) xpos=$(( $screenW/4 - $WIDTH/2 ))                ;;
    "right"  ) xpos=$(( $screenW   - $WIDTH   ))                ;;
    *        ) echo "Unknown x_align value: $x_align" && exit 1 ;;
esac

case "$y_align" in
    "top"    ) ypos=0                                           ;;
    "middle" ) ypos=$(( $screenH/2 - $HEIGHT/2 ))               ;;
    "bottom" ) ypos=$(( $screenH   - $HEIGHT   ))               ;;
    *        ) echo "Unknown y_align value: $y_align" && exit 1 ;;
esac

font="-*-fixed-medium-*-*-*-32-*-*-*-*-*-*-*"

parameters="  -p $timeout"
parameters+=" -fn $font"
parameters+=" -bg $colGrayBG"
parameters+=" -x $xpos -y $ypos -w $WIDTH -h $HEIGHT"

#parameters+=" -title-name dzenpopup"
#(echo $message | dzen2 $parameters &) && sleep .01s && transset-df -n dzenpopup 0.3

echo $message | dzen2 $parameters &
