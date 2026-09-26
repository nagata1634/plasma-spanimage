#!/usr/bin/env bash
# Build dev.yuya.spanimage-<version>.wallpaper.zip for the KDE Store / kpackagetool6 -t Plasma/Wallpaper -i
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; V="$(python3 -c 'import json;print(json.load(open("'"$HERE"'/package/metadata.json"))["KPlugin"]["Version"])')"
OUT="$HERE/dev.yuya.spanimage-$V.wallpaper.zip"; rm -f "$OUT"
( cd "$HERE/package" && zip -qr "$OUT" . -x '*.pyc' -x '*/__pycache__/*' ); echo "$(basename "$OUT")"
