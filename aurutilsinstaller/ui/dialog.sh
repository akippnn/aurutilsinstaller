#!/bin/bash

LINES=$(tput lines);
[ $(tput cols) -lt 96 ] && COLS="$(tput cols)" || COLS="96";

_confirm() {
	/usr/bin/dialog 3>&1 1>&2 2>&3 \
		--title "$1" \
		--yes-label "Y:Confirm" \
		--no-label "N:Cancel" \
		--yesno "$2" "$LINES" "$COLS" \
		&& return 0 || return 1;
}

_checklist() {
	local -n selected=$1 && shift || return 1;
	local title="$1" && shift;
	local counter=0;
	local items=();

	for i in "$@"; do
		if ! [ $((counter % 2)) -eq 0 ]; then
			items+=("$i");
			items+=(1);
		else
			items+=("$i");
		fi
		((counter++));
	done

	selected=($(/usr/bin/dialog 3>&1 1>&2 2>&3 \
		--title "$title" \
		--checklist "Mouse | Navigate: Arrow keys | Select: Space | Proceed: Enter" \
		"$LINES" "$COLS" 0 \
		"${items[@]}"
	))
}
