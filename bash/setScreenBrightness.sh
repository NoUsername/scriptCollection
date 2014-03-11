#!/bin/bash

# set screen brightness (very low on lenovo thinkpad twist)
$(echo "40" > /sys/class/backlight/intel_backlight/brightness) || true

exit 0
