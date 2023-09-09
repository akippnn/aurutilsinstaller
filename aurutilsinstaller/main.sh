#!/bin/bash

source "$PWD/aurutilsinstaller/parser.sh";
source "$PWD/aurutilsinstaller/interface.sh";

LINES=$(tput lines);
COLUMNS=$(tput cols);
INSTALLER_TITLE='aurutilsinstaller';
START_DIR="$PWD"
DEFAULT_UI='dialog';

trace() {
	((trace_num++));
	gum style --bold --margin="1 1" "Trace $trace_num";
	read;
}

fetch_files() {
	local -n file_arr=$1 || return 1;
	for file in "$START_DIR"/aurutilsinstaller/$2/*; do
		file_arr+=("$file")
	done
	trace
}

fetch_scripts() {
	local -n script_arr=$1 && shift || return 1;
	local -a return_file_arr;
	fetch_files return_file_arr "scripts";
	for file in ${return_file_arr[@]}; do
		local parsed;
		local -a lines;
		local -i count=0;
		while IFS= read -r line; do
			if [[ "$line" =~ "#% "* ]]; then
				line=${line#"#% "};
				lines+=("$line");
			fi
		done < "$file"
		# Function of parser.sh used here
		parse parsed 'desc' "${lines[@]}"
		echo "${parsed}"
		script_arr+=("$(basename "$file" .sh)" "${parsed}")
	done
} 

install() {
	local -a items;
	local -a run;

	fetch_scripts items;

	# Functions of interface.sh used here
	multiselect run "$1" "$INSTALLER_TITLE" "${items[@]}";
	if [ -z "$run" ]; then
		printf "Script to run not returned by %s." "$1";
		return 1;
	fi

	for script in "${run}"; do
		warnings=();
		source "$START_DIR/aurutilsinstaller/scripts/$script.sh";
		init;
		warnings+=("${NOTES[@]}");
	done;

	for warning in "${warnings[@]}"; do
		if ! $(confirm "$1" "$script.sh" "\n$warning"); then
			printf "Operation cancelled by user.";
			return 1;
		fi
	done
	clear;

	for script in "${run[@]}"; do
		source "$START_DIR/aurutilsinstaller/scripts/$script.sh";
		printf '\033[1m%s\033[0m\n' "$START_DIR/aurutilsinstaller/scripts/$script.sh";
		main;
		cd $START_DIR;
	done

	printf "Job finished.";
	return 0;
}

menu() {
	/dev/null
}

declare -a args=("$@");

if [[ ${#args[@]} -gt 0 && ${args[0]} != --* ]]; then
	declare -l ui_arg="${args[0]}"

	# Check if the UI script exists
	if [ -f "$START_DIR/aurutilsinstaller/ui/$ui_arg.sh" ]; then
		install "$ui_arg"
	else
		printf "'%s' is not an option.\n" "$ui_arg";
	fi

else
	printf "Usage:\n%s\n" "$0 <interface> [option]"
	cd "$START_DIR/aurutilsinstaller/ui"
	printf "\nInterfaces:\n%s\n" "$(find . -name "*.sh" -exec basename {} .sh \;)";
	exit 1

fi
printf " Exiting.\n"
