#!/usr/bin/env zsh

COLOR="$GREEN"

sketchybar \
	--add item sound right \
	--set sound \
	icon.color="$COLOR" \
	icon.padding_right=0 \
	label.color="$COLOR" \
	label.padding_left="$ICON_LABEL_PADDING" \
	background.border_color="$COLOR" \
	background.drawing=on \
	script="$PLUGIN_DIR/sound.sh" \
	--subscribe sound volume_change
