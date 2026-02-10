#!/usr/bin/env bash
# if [ -z "$WAYLAND_DISPLAY" ]; then
#   export DISPLAY=:0
#   export WAYLAND_DISPLAY=wayland-1
#   export XDG_RUNTIME_DIR="/run/user/$(id -u)"
#   export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
# fi
#
# export PATH="/usr/local/bin:/usr/bin:/bin:/opt/oomox:$PATH"
# export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
WALLPAPER="$(find "$WALLPAPER_DIR" -type f | shuf -n 1)"

# Aplica wallpaper
swww img "$WALLPAPER" \
  --transition-type grow \
  --transition-pos center \
  --transition-duration 1 \
  --transition-fps 60

# Gera paleta com Pywal
# wal -i "$WALLPAPER" -q

# Gera tema GTK com Oomox
# oomox-cli /home/dannielmamede/.cache/wal/colors-oomox

# Reinicia Waybar e atualiza Kitty
pkill waybar && waybar &
pkill -USR1 kitty 2>/dev/null

