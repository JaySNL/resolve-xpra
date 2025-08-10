#!/bin/bash

# Ensure XDG_RUNTIME_DIR is set for session bus if not present
if [ -z "${XDG_RUNTIME_DIR}" ]; then
    export XDG_RUNTIME_DIR="/tmp/${USERNAME}_runtime"
    mkdir -p "${XDG_RUNTIME_DIR}"
    chmod 0700 "${XDG_RUNTIME_DIR}"
fi

# Set the DISPLAY variable for the session
export DISPLAY=:0

# Clear any existing VNC processes if a stale session exists
# vncserver -kill :0 || true

# Start dbus-daemon session (important for XFCE components)
dbus-launch --exit-daemon --sh-syntax
eval $(dbus-launch --exit-daemon --sh-syntax)

# Start XFCE desktop environment
startxfce4

# Keep the script running to keep the X server alive
wait