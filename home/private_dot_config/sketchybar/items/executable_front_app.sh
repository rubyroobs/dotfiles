#!/usr/bin/env zsh

COLOR="$WHITE"

sketchybar \
	--add item front_app left \
	--set front_app script="$PLUGIN_DIR/front_app.sh" \
	icon.drawing=off \
	background.border_color="$COLOR" \
	label.color="$COLOR" \
	associated_display=active \
	--subscribe front_app front_app_switched
