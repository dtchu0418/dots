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

function inc_gaps_in () {
  hyprctl keyword general:gaps_in 2
}

function dec_gaps_in () {
  hyprctl keyword general:gaps_in 0
}

function inc_gaps_out () {
  hyprctl keyword general:gaps_out 5
}

function dec_gaps_out () {
  hyprctl keyword general:gaps_out 0
}

while [[ $# -gt 0 ]]; do
  case $1 in
    --inc_gaps_in)   inc_gaps_in;   shift ;;
    --dec_gaps_in)   dec_gaps_in;   shift ;;
    --inc_gaps_out)  inc_gaps_out;  shift ;;
    --dec_gaps_out)  dec_gaps_out;  shift ;;
    --toggle_gaps)   toggle_gaps;   shift ;;
    *)               printf "Error: Unknown option %s" "$1"; exit 1 ;;
  esac
done
