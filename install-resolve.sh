#!/bin/bash

# Script to download and install DaVinci Resolve
# Usage: ./install-resolve.sh [studio]

# Get the download URL from the Blackmagic Design website
# You will need to update this URL with the latest version
FREE_URL="https://www.blackmagicdesign.com/api/register/us/fulfillment/12345678-abcd-1234-abcd-1234567890ab/DaVinci_Resolve_18.5_Linux.zip"
STUDIO_URL="YOUR_STUDIO_URL_HERE" # You need to get this from the BMD website after purchase

URL=$FREE_URL
if [ "$1" == "studio" ]; then
    URL=$STUDIO_URL
fi

echo "Downloading DaVinci Resolve..."
wget -O /tmp/resolve.zip "$URL"

echo "Extracting..."
unzip /tmp/resolve.zip -d /tmp/resolve

echo "Installing..."
/tmp/resolve/*.run -i

echo "Cleaning up..."
rm -rf /tmp/resolve.zip /tmp/resolve

echo "DaVinci Resolve installation complete."