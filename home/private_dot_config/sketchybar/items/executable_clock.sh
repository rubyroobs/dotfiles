#!/usr/bin/env zsh

COLOR="$MAGENTA"

sketchybar --add item clock right \
	--set clock update_freq=1 \
	icon="" \
	icon.color="$COLOR" \
	icon.padding_right=0 \
	label.color="$COLOR" \
	label.padding_left="$ICON_LABEL_PADDING" \
	label.width=78 \
	align=center \
	background.padding_right=2 \
	background.border_color="$COLOR" \
	background.drawing=on \
	script="$PLUGIN_DIR/clock.sh"
