#!/bin/bash

parse() {
	local -n product=$1 || return 1;
	local select=$2;
	shift 2;
	local -A assoc_arr;
	local -a index_arr;
	local -a lines=("$@");

	printf "%s\n" "${lines[@]}"
	for element in "${lines[@]}"; do
		echo ">$element";
		local keyword=$(echo $element | awk '{print $1}');
		local first_word=$(echo $element | awk '{print $2}');
		local rest_of_string=$(echo $element | cut -d' ' -f3-);
		case $keyword in
			'desc')
				echo "1"
				assoc_arr["desc"]="$first_word $rest_of_string"
				;;
			'bool')
				echo "2"
				index_arr+=("bool'$first_word'$rest_of_string")
				;;
			'string')
				echo "3"
				index_arr+=("string'$first_word'$rest_of_string")
				;;
			*)
				echo "4"
				printf "Invalid keyword: %s" "$keyword"
				;;
		esac
	done

	case "$select" in
		'desc')
			product="${assoc_arr["desc"]}"
			;;
		'input')
			product="${index_arr[@]}"
			;;
	esac

	trace
}
