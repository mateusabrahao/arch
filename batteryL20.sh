#!/bin/bash
# checks if any battery is below 20% and sends notification via twmnc every 5 minutes

set -euo pipefail

THRESHOLD=20
CHECK_INTERVAL=300
STATE_FILE="/tmp/battery_notify_state"

if [ ! -f "$STATE_FILE" ]; then
    echo "0" > "$STATE_FILE"
fi

while true; do
    for BAT in /sys/class/power_supply/BAT*/; do
        [ -d "$BAT" ] || continue

        LEVEL=$(<"${BAT}/capacity")
        STATUS=$(<"${BAT}/status" 2>/dev/null || echo "Unknown")

        [[ "$LEVEL" =~ ^[0-9]+$ ]] || continue

        if [[ "$STATUS" == "Discharging" && "$LEVEL" -le "$THRESHOLD" ]]; then
            LAST_STATE=$(<"$STATE_FILE")
            if [ "$LAST_STATE" -ne 1 ]; then
                twmnc --title "Warning" \
                      --content "Battery is getting low!" \
                      --timeout 8000 \
                      --id "battery_low"
                echo "1" > "$STATE_FILE"
            fi
        else
            echo "0" > "$STATE_FILE"
        fi
    done
    sleep "$CHECK_INTERVAL"
done
