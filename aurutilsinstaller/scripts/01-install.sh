#!/bin/bash
#% Install aurutilsinstaller
#% Install wizard for aurutils (interactive)

source "$PWD/deps/aurutils/PKGBUILD"

main() {
	echo "aurutils depends on the following:"
	for dep in "${depends[@]}"; do
		echo "	$dep"
	done

}
