#!/usr/bin/env bash
set -euo pipefail
pulseaudio --start --exit-idle-time=-1 || true
if [[ -n "${WEBDAV_URL}" ]]; then /opt/scripts/mount-webdav.sh || true; fi
xpra start :100 \
  --bind-tcp=0.0.0.0:8080 \
  --html=on --start-child="startxfce4" \
  --opengl=yes --video-encoders=all --audio-codec=all \
  --exit-with-children=yes --daemon=no
