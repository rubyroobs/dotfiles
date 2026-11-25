#!/usr/bin/env bash
set -euo pipefail

[[ "$OSTYPE" == "darwin"* ]] || exit 0
command -v dockutil >/dev/null 2>&1 || exit 0

removed=0
for label in \
    Safari \
    FaceTime \
    Maps \
    Photos \
    Contacts \
    Calendar \
    Reminders \
    Podcasts \
    TV \
    News \
    Numbers \
    Keynote \
    Pages
do
    if dockutil --find "$label" >/dev/null 2>&1; then
        dockutil --no-restart --remove "$label"
        removed=1
    fi
done

if [ "$removed" -eq 1 ]; then
    killall Dock || true
fi
