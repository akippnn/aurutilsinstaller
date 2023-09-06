#!/bin/bash

dialog="/usr/bin/dialog 3>&1 1>&2 2>&3" 

# Bash is a headache...Had to go through trial and error until I realized
# that I just needed to encase the scripts variable in double quotes
main() {
	local -n selected=$1 && shift || return 1;
	for item in "$@"; do
		echo "$item";
	done
	#selected=eval $dialog \
		#--checklist "Mouse | Navigate: Arrow keys | Select: Space | Proceed: Enter" \
		#$@
}
