#!/usr/bin/env bash
set -euo pipefail
mkdir -p /workspace/install
FILE=$(ls -1 /workspace/install/DaVinci_Resolve_*_Linux.run 2>/dev/null | head -n1 || true)
[[ -n "${FILE}" ]] || { echo "Put DaVinci_Resolve_*_Linux.run in /workspace/install/"; exit 1; }
cd /opt/MakeResolveDeb
./makeresolvedeb -i "${FILE}" -o /workspace/install/
DEB=$(ls -1 /workspace/install/davinci-resolve*_amd64.deb | head -n1)
sudo dpkg -i "$DEB" || sudo apt-get -f install -y
echo "Resolve installed"
