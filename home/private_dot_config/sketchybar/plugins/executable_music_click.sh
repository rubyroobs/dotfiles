#!/usr/bin/env zsh

yabai -m window --focus "$(yabai -m query --windows | jq 'map(select(.app == "Music")) | .[0].id')"
