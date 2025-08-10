#!/usr/bin/env bash
set -euo pipefail
mkdir -p /workspace/install
FILE=$(ls -1 /workspace/install/DaVinci_Resolve_*_Linux.run 2>/dev/null | head -n1 || true)
[[ -n "${FILE}" ]] || { echo "Put DaVinci_Resolve_*_Linux.run in /workspace/install/"; exit 1; }
chmod +x "${FILE}"
# Run the official GUI installer under Xpra/Xfce
sudo -E "${FILE}"
echo "If installer completed, launch with 'resolve' or from Applications → Multimedia."
