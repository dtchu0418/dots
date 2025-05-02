#!/usr/bin/env bash

# Declaring power-profiles state
STATE=$(powerprofilesctl get)

# Change mode
if [ "$STATE" = "power-saver" ]; then
    powerprofilesctl set performance
    dunstify -a "POWER-PROFILE" "Power-Profile set to performance"
elif [ "$STATE" = "performance" ]; then
    powerprofilesctl set balanced
    dunstify -a "POWER-PROFILE" "Power-Profile set to balanced"
elif [ "$STATE" = "balanced" ]; then
    powerprofilesctl set power-saver
    dunstify -a "POWER-PROFILE" "Power-Profile set to power-saver"
fi
