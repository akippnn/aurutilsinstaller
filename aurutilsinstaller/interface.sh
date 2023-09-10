#!/bin/bash

confirm() {
	local interface_script="$1"
	local header="$2"
	local -a messages="$3"

	source "$PWD/aurutilsinstaller/ui/$interface_scirpt.sh";
	_confirm "$header" "$messages" || return 1;
}

multiselect() {
	local -n selected_option=$1;
	local interface_script="$2";
	local header="$3"
	# $@ array: items ( repeat of [0] tag, [1] item )
	shift 3;

	source "$PWD/aurutilsinstaller/ui/$interface_script.sh";
	_multiselect selected_option "$header" "$@" || return 1;
	return 0;
}

menu() {
	local -n selected_option=$1;
	local interface_script="$2";
	local header="$3";
	# $@ array: menu items ( repeat of [0] tag, [1] item )
	shift 3;

	source "$PWD/aurutilsinstaller/ui/$interface_script.sh";
	_menu selected_option "$header" "$@" || return 1;
	return 0;
}
