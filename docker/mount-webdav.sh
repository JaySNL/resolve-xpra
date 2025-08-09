#!/usr/bin/env bash
set -euo pipefail
mkdir -p "${WEBDAV_MOUNT}"
case "${WEBDAV_MODE}" in
  rclone)
    rclone mount ":webdav,url=${WEBDAV_URL},vendor=${WEBDAV_VENDOR},user=${WEBDAV_USER},pass=${WEBDAV_PASS}:/" \
      "${WEBDAV_MOUNT}" --vfs-cache-mode full --allow-other --daemon
    ;;
  gvfs)
    # FUSE-less fallback; shows up under /run/user/$(id -u)/gvfs
    printf "%s" "${WEBDAV_PASS}" | \
      gio mount -i "davs://${WEBDAV_USER}@${WEBDAV_URL#https://}" || true
    ;;
esac
