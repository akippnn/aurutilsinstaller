#!/bin/bash

REQUIRES=$('dialog')
LINES=$(tput lines);
[ $(tput cols) -lt 96 ] && COLS="$(tput cols)" || COLS='96';

_confirm() {
	/usr/bin/dialog 3>&1 1>&2 2>&3 \
		--title "$1" \
		--yes-label 'Y:Confirm' \
		--no-label 'N:Cancel' \
		--yesno "$2" 8 78 \
		&& return 0 || return 1;
}

_multiselect() {
	local -n selected=$1|| return 1;
	local title="$2";
	shift 2;
	local -a items;
	for test in "$@"; do
		items+=("$test")
	done
	local -a modified_items;

	for ((i = 1; i < "${#items[@]}"; i += 2)); do
		modified_items+=("${items[i]}" "${items[i+1]}" "0")
	done

	selected=($(/usr/bin/dialog 3>&1 1>&2 2>&3 \
		--title "$title" \
		--checklist 'Mouse | Navigate: Arrow keys | Select: Space | Proceed: Enter' \
		"$LINES" "$COLS" 0 \
		"${modified_items[@]}"
	))
}

_menu() {
    local -n selected=$1 || return 1;
    local title="$2";
    shift 2;
    local items="$@";

    selected=$(/usr/bin/dialog 3>&1 1>&2 2>&3 \
        --title "$title" \
        --menu 'Mouse | Navigate: Arrow keys | Select: Space | Proceed: Enter' \
        "$LINES" "$COLS" 0 \
        "${items[@]}"
    )
}
