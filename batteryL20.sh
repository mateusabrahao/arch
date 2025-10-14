#!/bin/bash
# checks if any battery is below 20% and sends notification via twmnc every 5 minutes

THRESHOLD=20
NOTIFY_SENT=0

i3status | while read -r line; do
    if [[ $line =~ ([0-9]+)% ]]; then
        LEVEL=${BASH_REMATCH[1]}
        STATUS=$(echo "$line" | grep -Eo "Discharging|Charging|Full|Unknown")

        if [ "$STATUS" = "Discharging" ]; then
            if [ "$LEVEL" -le "$THRESHOLD" ] && [ "$NOTIFY_SENT" -eq 0 ]; then
                twmnc --title "Battery Warning" --content "Battery low: ${LEVEL}%"
                NOTIFY_SENT=1
            elif [ "$LEVEL" -gt "$THRESHOLD" ]; then
                NOTIFY_SENT=0
            fi
        else
            NOTIFY_SENT=0
        fi
    fi

    echo "$line"
done
