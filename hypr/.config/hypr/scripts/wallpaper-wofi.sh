#!/bin/bash

DIR="$HOME/.config/hypr/wallpapers"

IMG=$(ls "$DIR" | wofi --dmenu --prompt "Wallpaper")

[ -z "$IMG" ] && exit 0

swww img "$DIR/$IMG" \
  --transition-type wipe \
  --transition-duration 2 \
  --transition-fps 100

