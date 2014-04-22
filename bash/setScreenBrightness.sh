#!/bin/bash
# set screen brightness (very low on lenovo thinkpad twist)

# default value 40 (very dark) can be changed via an optional argument
B_VAL=40
if [ "$#" -gt "0" ]; then
 B_VAL="$1"
fi

bash -c "echo \"${B_VAL}\" > /sys/class/backlight/intel_backlight/brightness"

