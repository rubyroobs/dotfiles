#!/usr/bin/env zsh

COLOR="$CYAN"

sketchybar --add item battery right \
	--set battery \
	update_freq=60 \
	icon.color="$COLOR" \
	icon.padding_right=0 \
	label.color="$COLOR" \
	label.padding_left="$ICON_LABEL_PADDING" \
	background.border_color="$COLOR" \
	background.drawing=on \
	script="$PLUGIN_DIR/power.sh" \
	--subscribe battery power_source_change
