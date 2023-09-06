#!/bin/bash

LINES=$(tput lines);
COLUMNS=$(tput cols);
TITLE='aurutilsinstaller';
DEFAULT_UI='dialog-checklist';

trace() {
	((tracenum++)); gum style --bold --margin="1 1" "Trace $tracenum";
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
	local files;
	fetch files "scripts";
	for file in ${files[@]}; do
		lines=();
		count=0;
		while IFS= read -r line; do
			if [[ $line == "#% "* ]]; then
				line=${line#"#% "}
				lines+=("$line")
				((count++))
				((count == 2)) && break
			fi
		done < "$file"
		scripts+=("$(basename "$file" .sh)" "${lines[0]}: ${lines[1]}" 0)
	done
} 

fetch_ui() {
	local -n ui=$1;
	local files;
	fetch files "ui";
	for file in ${files[@]}; do
		ui+=("$file");
	done
}

ui() {
	# $1 string: use this ui
	local -n user_selected=$1 && shift || return 1;
	local uis;
	local select;
	fetch_ui uis;

	if ! [[ ${uis[@]} =~ $1 ]]; then
		echo "$1 is not a UI provided by $TITLE";
		return 1;
	fi
	for i in ${uis[@]}; do
		if [[ $(basename "$i" .sh) = $1 ]]; then
			echo "$1 found: $i";
			select=$i;
		fi
	done

	source "$select";
	trace;
	shift && main user_selected "$@";
}

init() {
	# $1 string: use this ui
	local use_script;
	local whots;
	trace;
	fetch_scripts whots;
	for item in "${whots[@]}"; do
		echo "$item";
	done
	trace;
	echo "Opening $1";
	ui use_script "$1" "$TITLE" "${whots[@]}"
	echo "$use_script";
}

args=();

while [ "$#" -gt 0 ]; do
	echo $1;
	args+="$1";
	shift;
done

if [ ${#args[@]} -eq 0 ]; then
	init $DEFAULT_UI
fi

#selected=($(/usr/bin/dialog 3>&1 1>&2 2>&3 \
	#--title $TITLE \
	#--checklist "Mouse | Navigate: Arrow keys | Select: Space | Proceed: Enter" $LINES 96 0 \
	#"${scripts[@]}"
#))

#for script in "${selected[@]}"; do
	#source "${PWD}/aurutilsinstaller/scripts/${script}.sh"
	#clear
	#main
#done
