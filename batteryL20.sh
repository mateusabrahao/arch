#!/bin/bash
# checks if any battery is below 20% and sends notification via twmnc every 5 minutes

while true; do
    for BATTERY_PATH in /sys/class/power_supply/BAT*/uevent; do
        BATTERY_LEVEL=$(awk -F= '/POWER_SUPPLY_CAPACITY/ {print $2}' "$BATTERY_PATH")
        BATTERY_NAME=$(basename $(dirname "$BATTERY_PATH"))

        if [ "$BATTERY_LEVEL" -le 20 ]; then
            twmnc "Warning" "Battery is getting low!"
        fi
    done

    sleep 300  # check every 5 minutes
done
