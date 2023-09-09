#!/bin/bash

confirm() {
	# $1 string & shift: interface script to use
	# $2 string: header
	# $3 string: array of messages
	
	source "$PWD/aurutilsinstaller/ui/$1.sh";
	_confirm "$2" "$3" || return 1;
}

multiselect() {
	# $1 nameref & shift: return names of options selected
	# $2 string: interface script to use
	# $@ array: header, then repeat of ( [0] name, [1] description )
	
	local -n user_selected=$1;
	source "$PWD/aurutilsinstaller/ui/$2.sh";
	shift 2;
	_multiselect user_selected "$@" || return 1;

	return 0;
}
