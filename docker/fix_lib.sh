#!/bin/bash

echo "Running DaVinci Resolve library fixes..."

# Path to Resolve's lib directory. Adjust if Resolve is installed elsewhere.
RESOLVE_LIB_DIR="/opt/resolve/libs"

# Check if Resolve's lib directory exists
if [ ! -d "$RESOLVE_LIB_DIR" ]; then
    echo "Warning: DaVinci Resolve library directory not found at $RESOLVE_LIB_DIR. Skipping library fixes."
    exit 0
fi

# Create a symlink for libcrypt.so.1 if it doesn't exist and libcrypt.so.2 is present
if [ ! -f /lib64/libcrypt.so.1 ] && [ -f /lib64/libcrypt.so.2 ]; then
    echo "Symlinking libcrypt.so.2 to libcrypt.so.1..."
    ln -s /lib64/libcrypt.so.2 /lib64/libcrypt.so.1
fi

# Ensure Resolve uses its own bundled libraries for critical components
# by prepending its library path to LD_LIBRARY_PATH.
# This prevents conflicts with system libraries.
# Add a wrapper script to the Resolve executable to always use this path.
RESOLVE_BIN="/opt/resolve/bin/resolve"
WRAPPER_SCRIPT_PATH="/usr/local/bin/resolve"

echo "#!/bin/bash" | sudo tee "$WRAPPER_SCRIPT_PATH"
echo "export LD_LIBRARY_PATH=\"$RESOLVE_LIB_DIR:\$LD_LIBRARY_PATH\"" | sudo tee -a "$WRAPPER_SCRIPT_PATH"
echo "exec \"$RESOLVE_BIN\" \"\$@\"" | sudo tee -a "$WRAPPER_SCRIPT_PATH"
sudo chmod +x "$WRAPPER_SCRIPT_PATH"

echo "Library fixes applied. DaVinci Resolve is now wrapped to use its bundled libraries."