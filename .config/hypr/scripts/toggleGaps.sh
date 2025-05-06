#!/usr/bin/env bash

gaps_in=$(hyprctl -j getoption general:gaps_in | jq '.custom' | awk '{print $1}' | cut -c 2-)
gaps_out=$(hyprctl -j getoption general:gaps_out | jq '.custom' | awk '{print $1}' | cut -c 2-)

function toggle_gaps () {
    if [ $gaps_in -eq 2 ]
    then
        hyprctl keyword general:gaps_in 0;
        hyprctl keyword general:gaps_out 0;
        hyprctl keyword decoration:rounding 0;
    else
        hyprctl keyword general:gaps_in 2;
        hyprctl keyword general:gaps_out 5;
        hyprctl keyword decoration:rounding 18;
    fi
}

while [[ $# -gt 0 ]]; do
  case $1 in
    --toggle_gaps)   toggle_gaps;   shift ;;
    *)               printf "Error: Unknown option %s" "$1"; exit 1 ;;
  esac
done
