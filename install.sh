#!/bin/bash
# Installs (or updates) Emergency Mac into /Applications from the latest release.
#   curl -fsSL https://raw.githubusercontent.com/nikotsy/emergency-mac/main/install.sh | bash
set -euo pipefail
REPO=nikotsy/emergency-mac
APP="/Applications/Emergency Mac.app"

echo "Finding the latest Emergency Mac…"
URL=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
  | grep -o '"browser_download_url": *"[^"]*\.zip"' | head -1 | sed -E 's/.*"(https[^"]+)"/\1/')
[ -n "$URL" ] || { echo "Couldn't find a release to download." >&2; exit 1; }

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
echo "Downloading $(basename "$URL")…"
curl -fsSL "$URL" -o "$TMP/app.zip"
ditto -x -k "$TMP/app.zip" "$TMP/x"
[ -d "$TMP/x/Emergency Mac.app" ] || { echo "The download didn't contain the app." >&2; exit 1; }

if pgrep -x EmergencyMac >/dev/null; then echo "Quitting the running copy…"; pkill -x EmergencyMac || true; sleep 1; fi
rm -rf "$APP"
mv "$TMP/x/Emergency Mac.app" "$APP"
xattr -dr com.apple.quarantine "$APP" 2>/dev/null || true
echo "Installed to $APP"
open "$APP"
echo "Emergency Mac is running: look for the circle in your menu bar."
