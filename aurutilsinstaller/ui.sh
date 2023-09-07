#!/bin/bash

confirm() {
	# $1 string & shift: use this ui
	# $1 string: header
	# $2 string: array of messages
	
	source "$PWD/aurutilsinstaller/ui/$1.sh" && shift || return 1;
	_confirm "$1" "$2" && return 0 || return 1;
}

checklist() {
	# $1 string & shift: use this ui
	# $1 string & shift: header
	# $@ array: repeat of ( [0] script, [1] name + description )
	# returns string: scripts to use
	
	local -n user_selected=$1 && shift || return 1;
	source "$PWD/aurutilsinstaller/ui/$1.sh" && shift && \
	_checklist user_selected "$@" || return 1;
	return 0;
}
