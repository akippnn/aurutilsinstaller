#!/bin/bash
#% Install aurutilsinstaller
#% Install wizard for aurutils (interactive)

source "$(pwd)/aurutils/PKGBUILD"

main() {
	echo "aurutils depends on the following:"
	for dep in "${depends[@]}"; do
		echo "	$dep"
	done
	echo "WIP"
	read
}
