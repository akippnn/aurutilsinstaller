#!/bin/bash
#% name install-aurutils
#% desc Install aurutils: Compile and install aurutils inside pkgs
#% bool offline Install offline?

init() {
	git submodule update "$PWD/pkgs/aurutils"
	source "$PWD/pkgs/aurutils/PKGBUILD"
	NOTES=("aurutils depends on the following: $(printf '%s\n' `echo "${depends[@]}"`)" "Another note just in case!")
}

main() {
	printf '%s\n' "aurutils depends on the following:"
	printf '\t%s\n' "${depends[@]}"
	cd pkgs/aurutils;
	printf '\033[38;5;240m'
	makepkg
}
