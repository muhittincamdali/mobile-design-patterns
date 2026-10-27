#!/usr/bin/env bash
# Captures the README screenshots from the PatternGallery example app on an iPhone simulator.
#
# The script builds and installs the app, opens each screen with `-screen <name>`, and takes a
# simulator screenshot in light and dark appearance with a fixed status bar. The articles screen
# is captured after its sample data has loaded.
#
# Usage: scripts/capture-screens.sh [simulator name or UDID]
# Without an argument it uses the first available iPhone simulator. Output: docs/images/
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
device="${1:-}"
if [[ -z "$device" ]]; then
  device="$(xcrun simctl list devices available | grep -m1 -oE 'iPhone [^(]+' | sed 's/ *$//')"
fi
if [[ -z "$device" ]]; then
  echo "No available iPhone simulator found." >&2
  exit 1
fi

bundle_id="io.github.muhittincamdali.PatternGallery"
screens=(articles checkout editor cart links)
output_dir="$repo_root/docs/images"
build_dir="$(mktemp -d)"
trap 'rm -rf "$build_dir"' EXIT
mkdir -p "$output_dir"

destination="platform=iOS Simulator,name=$device"
if [[ "$device" =~ ^[0-9A-F-]{36}$ ]]; then
  destination="platform=iOS Simulator,id=$device"
fi

echo "Building PatternGallery for '$device'"
xcodebuild build \
  -project "$repo_root/Examples/PatternGallery/PatternGallery.xcodeproj" \
  -scheme PatternGallery \
  -destination "$destination" \
  -derivedDataPath "$build_dir" \
  -quiet
app="$(find "$build_dir/Build/Products" -maxdepth 2 -name 'PatternGallery.app' -path '*iphonesimulator*' | head -1)"

xcrun simctl boot "$device" 2>/dev/null || true
xcrun simctl bootstatus "$device" -b >/dev/null
xcrun simctl status_bar "$device" override --time 9:41 --batteryState charged --batteryLevel 100 \
  --cellularBars 4 --wifiBars 3 --operatorName ""
xcrun simctl install "$device" "$app"

for appearance in light dark; do
  xcrun simctl ui "$device" appearance "$appearance"
  for screen in "${screens[@]}"; do
    xcrun simctl terminate "$device" "$bundle_id" 2>/dev/null || true
    xcrun simctl launch "$device" "$bundle_id" -screen "$screen" >/dev/null
    # Lets the launch animation end and the sample articles (600 ms delay) arrive.
    sleep 3
    xcrun simctl io "$device" screenshot --type=png "$output_dir/$screen-$appearance.png" >/dev/null
    echo "Saved $screen-$appearance.png"
  done
done

xcrun simctl terminate "$device" "$bundle_id" 2>/dev/null || true
xcrun simctl status_bar "$device" clear
xcrun simctl ui "$device" appearance light
