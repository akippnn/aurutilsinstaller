#!/bin/bash

source "$PWD/aurutilsinstaller/ui.sh";

LINES=$(tput lines);
COLUMNS=$(tput cols);
TITLE='aurutilsinstaller';
DEFAULT_UI='dialog';

trace() {
	((tracenum++)); gum style --bold --margin="1 1" "Trace $tracenum";
	read;
}

fetch() {
	# $1 string: fetch files from this folder
	
	local -n arr=$1 && shift || return 1;
	for file in "$PWD"/aurutilsinstaller/$1/*; do
		arr+=("$file")
	done
}

fetch_scripts() {
	local -n scripts=$1 && shift || return 1;
	local files=();
	fetch files "scripts";
	for file in ${files[@]}; do
		lines=();
		count=0;
		while IFS= read -r line; do
			if [[ "$line" =~ "#% "* ]]; then
				line=${line#"#% "};
				lines+=("$line");
				((count++));
				((count == 2)) && break;
			fi
		done < "$file"
		scripts+=("$(basename "$file" .sh)" "${lines[0]}: ${lines[1]}");
	done
} 

init() {
	# $1 string: use this ui
	
	#local interfaces=();
	local items=();
	local use_script=();

	#fetch_ui interfaces;
	fetch_scripts items;

	checklist use_script "$1" "$TITLE" "${items[@]}";
	for script in "${use_script[@]}"; do
		NOTES=();
		source "$PWD/aurutilsinstaller/scripts/$script.sh";
		if ! [ -z "$NOTES" ]; then
			for note in "${NOTES[@]}"; do
				local n;
				((n++))
				if ! $(confirm "$1" "$script.sh" "Note $n: \n$note"); then
					printf '%s' "Cancelled";
					kill;
				fi
			done
		fi
	done;

	unset main;
	unset NOTES;

	for script in "${use_script[@]}"; do
		clear;
		source "$PWD/aurutilsinstaller/scripts/$script.sh";
		printf '\033[1m%s\033[0m\n' "$PWD/aurutilsinstaller/scripts/$script.sh";
		main;

		unset main;
	done
}

args=();

while [ "$#" -gt 0 ]; do
	echo $1;
	args+="$1";
	shift;
done

if [ ${#args[@]} -eq 0 ]; then
	init "$DEFAULT_UI";
fi
