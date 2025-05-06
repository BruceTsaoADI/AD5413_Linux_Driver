#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Script Name : install_dtbo.sh
# Description : Compile ad5413.dts into a DTBO and install it to /boot/overlays
# Note        : Must be run as root (or via sudo)
# -----------------------------------------------------------------------------

set -euo pipefail
IFS=$'\n\t'

OVERLAY_DTS="ad5413.dts"
DTBO="${OVERLAY_DTS%.dts}.dtbo"
OVERLAY_DIR="/boot/firmware/overlays"

# 1. Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "ERROR: This script must be run as root." >&2
  exit 1
fi

# 2. Check that dtc is installed
if ! command -v dtc &>/dev/null; then
  echo "ERROR: 'dtc' command not found. Please install device-tree-compiler." >&2
  exit 1
fi

# 3. Check that the DTS file exists
if [[ ! -f "$OVERLAY_DTS" ]]; then
  echo "ERROR: DTS file '$OVERLAY_DTS' not found in current directory." >&2
  exit 1
fi

# 4. Compile DTS to DTBO
echo "INFO: Compiling '$OVERLAY_DTS' to '$DTBO'..."
if ! dtc -@ -I dts -O dtb -o "$DTBO" "$OVERLAY_DTS"; then
  echo "ERROR: Compilation failed." >&2
  exit 1
fi

# 5. Create overlays directory if it doesn't exist
if [[ ! -d "$OVERLAY_DIR" ]]; then
  echo "INFO: Directory '$OVERLAY_DIR' not found."
fi

# 6. Copy the DTBO into /boot/firmware/overlays
echo "INFO: Copying '$DTBO' to '$OVERLAY_DIR/'..."
if ! cp -v "$DTBO" "$OVERLAY_DIR/"; then
  echo "ERROR: Failed to copy '$DTBO' to '$OVERLAY_DIR'." >&2
  exit 1
fi

echo "SUCCESS: '$DTBO' has been installed to '$OVERLAY_DIR'."
