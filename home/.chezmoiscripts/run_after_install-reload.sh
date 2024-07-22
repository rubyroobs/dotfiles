#!/bin/bash

# VS Code
if [ -d "$HOME/Library/Application Support" ]; then
    mkdir -p "$HOME/Library/Application Support/Code/User"
    cp "$HOME/.config/Code/User/settings.json" "$HOME/Library/Application Support/Code/User/"
    cp "$HOME/.config/Code/User/keybindings.json" "$HOME/Library/Application Support/Code/User/"
    cp -R "$HOME/.config/Code/User/snippets" "$HOME/Library/Application Support/Code/User/"
fi

if command -v fc-cache > /dev/null 2>&1; then
    fc-cache
fi

if command -v skhd > /dev/null 2>&1; then
    skhd --stop-service
    skhd --start-service
fi

if command -v sketchybar > /dev/null 2>&1; then
    sketchybar --reload
fi

if command -v kitty > /dev/null 2>&1; then
    pgrep kitty | xargs kill -SIGUSR1
fi
