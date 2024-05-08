#!/usr/bin/env bash

COLOR="$RED"
SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

sketchybar --add item spacer.1 left \
	--set spacer.1 background.padding_right=8 \
	background.padding_left=0 \
	label.drawing=off \
	icon.drawing=off

for i in {0..9}; do
	sid=$((i + 1))
	sketchybar --add space space.$sid left \
		--set space.$sid associated_space=$sid \
		label.drawing=off \
		icon.padding_left=2 \
		icon.padding_right=2 \
		background.drawing=off \
		script="$PLUGIN_DIR/space.sh"
done

sketchybar --add item spacer.2 left \
	--set spacer.2 background.padding_left=8 \
	background.padding_right=0 \
	label.drawing=off \
	icon.drawing=off

sketchybar --add bracket spaces '/space.*/' \
	--set spaces background.border_color="$COLOR" \
	background.drawing=on \
	background.padding_left=0 \
	background.padding_right=0

sketchybar --add item separator left \
	--set separator icon="" \
	icon.font="$FONT:Regular:16.0" \
	icon.padding_left=8 \
	icon.padding_right=4 \
	label.drawing=off \
	background.drawing=off \
	associated_display=active \
	icon.color="$YELLOW"
