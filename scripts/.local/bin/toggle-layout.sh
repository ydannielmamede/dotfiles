#!/bin/bash

CURRENT=$(hyprctl getoption general:layout | grep "str:" | awk '{print $2}' | tr -d '"')

case $CURRENT in
    dwindle) hyprctl keyword general:layout scrolling ;;
    *)       hyprctl keyword general:layout dwindle ;;
esac
