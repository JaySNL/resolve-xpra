#!/usr/bin/env bash
set -euo pipefail

# derive uid/gid; do not rely on $USER (unset under RunPod)
UIDNUM="$(id -u)"
GIDNUM="$(id -g)"

# runtime dirs
sudo mkdir -p /run/dbus "/run/user/${UIDNUM}"
sudo chown -R "${UIDNUM}:${GIDNUM}" "/run/user/${UIDNUM}"

export XDG_RUNTIME_DIR="/run/user/${UIDNUM}"
export DBUS_SYSTEM_BUS_ADDRESS="unix:path=/run/dbus/system_bus_socket"
export HOME="${HOME:-/home/pod}"

# system bus for gvfs/xfce bits
sudo /usr/bin/dbus-daemon --system --address="${DBUS_SYSTEM_BUS_ADDRESS}" --nopidfile --nosyslog --nofork >/dev/null 2>&1 || true

# audio
pulseaudio --start --exit-idle-time=-1 || true

# optional polkit agent (ignore if missing)
( /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 >/dev/null 2>&1 || true ) &

# xpra html5 server (reverse-proxy aware)
exec dbus-run-session \
  xpra start :100 \
    --bind-tcp=0.0.0.0:8080 \
    --html=on \
    --tcp-proxy=yes \
    --auth=none \
    --start-child="startxfce4" \
    --opengl=yes \
    --video-encoders=all \
    --exit-with-children=yes \
    --daemon=no
