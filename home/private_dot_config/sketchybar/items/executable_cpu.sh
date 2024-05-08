#!/usr/bin/env zsh

COLOR="$YELLOW"

sketchybar --add item cpu right \
	--set cpu \
	update_freq=3 \
	icon.color="$COLOR" \
	icon.padding_right=0 \
	label.color="$COLOR" \
	label.padding_left="$ICON_LABEL_PADDING" \
	background.padding_right=5 \
	background.border_color="$COLOR" \
	background.drawing=on \
	script="$PLUGIN_DIR/cpu.sh"
