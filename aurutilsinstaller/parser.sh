#!/bin/bash

parse() {
	local -n product=$1 || return 1;
	local select=$2;
	shift 2;

	local -A assoc_arr;
	local -a index_arr;
	local -a lines=("$@");

	for element in "${lines[@]}"; do
		local keyword first_word rest_of_string
		read -r keyword first_word rest_of_string <<< "$element";
		# Similar to:
		# local keyword=$(echo $element | awk '{print $1}');
		# local first_word=$(echo $element | awk '{print $2}');
		# local rest_of_string=$(echo $element | cut -d' ' -f3-);

		case $keyword in
			'name')
				assoc_arr['name']="$first_word"
				;;
			'desc')
				assoc_arr['desc']="$first_word $rest_of_string"
				;;
			'bool')
				index_arr+=("bool'$first_word'$rest_of_string")
				;;
			'string')
				index_arr+=("string'$first_word'$rest_of_string")
				;;
			*)
				printf "Invalid keyword: %s" "$keyword"
				;;
		esac
	done

	if [ -n "$select" ]; then
		if [ "$select" == 'info' ]; then
			for item in "${!assoc_arr[@]}"; do
				product["$item"]="${assoc_arr["$item"]}";
			done
		elif [ "$select" == 'input' ]; then
			product="${index_arr[@]}";
		elif [ -n "${assoc_arr[$select]}" ]; then
			product["$select"]="${assoc_arr["$select"]}";
		else
			printf "Invalid selection: %s" "$select";
		fi
	else
		printf "No selection specified.";
	fi
}
