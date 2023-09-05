#!/bin/bash

LINES=$(tput lines)
COLUMNS=$(tput cols)
TITLE='aurutilsinstaller'

intro() {
	/dev/null
}

if [ $(($LINES - 16)) -lt 0 ]; then
	>&2 echo "Terminal too small"
	return 1
fi

current_dir=$(pwd)
scripts=()

for file in "$current_dir"/scripts/*.sh; do
	lines=()
	count=0
	while IFS= read -r line; do
		if [[ $line == "#% "* ]]; then
			line=${line#"#% "}
			lines+=("$line")
			((count++))
			if ((count == 2)); then
				break
			fi
		fi
	done < "$file"
	scripts+=("$(basename "$file" .sh)" "${lines[0]}: ${lines[1]}" 0)
done

# Bash is a headache...Had to go through trial and error until I realized
# that I just needed to encase the scripts variable in double quotes
runscripts=($(/usr/bin/dialog 3>&1 1>&2 2>&3 \
	--title $TITLE \
	--checklist "Mouse | Navigate: Arrow keys | Select: Space | Proceed: Enter" $LINES 96 0 \
	"${scripts[@]}"
	))

for script in "${runscripts[@]}"; do
	source "${current_dir}/scripts/${script}.sh"
	clear
	main
done
