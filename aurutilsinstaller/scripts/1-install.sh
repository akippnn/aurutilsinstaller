#!/bin/bash
#% Install aurutilsinstaller
#% Install wizard for aurutils (interactive)

source "$PWD/pkgs/aurutils/PKGBUILD"

NOTES=("aurutils depends on the following: $(printf '%s' `echo "${depends[@]}"`)"
	"Another note just in case!")

main() {
	printf '%s\n' "aurutils depends on the following:"
	for dep in "${depends[@]}"; do
		echo "	$dep"
	done
}
