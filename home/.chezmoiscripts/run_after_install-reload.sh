#!/usr/bin/env bash

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

if command -v sxhkd > /dev/null 2>&1; then
    sv restart $HOME/.runit/runsvdir/sxhkd
fi

if command -v kitty > /dev/null 2>&1; then
    pgrep kitty | xargs kill -SIGUSR1
fi

if command -v bspwm > /dev/null 2>&1; then
    DISPLAY=:0 ~/.config/bspwm/bspwmrc > /dev/null 2>&1 &
fi

if command -v hx > /dev/null 2>&1; then
    pgrep kitty | xargs kill -SIGUSR1
fi
