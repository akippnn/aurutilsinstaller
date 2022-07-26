#!/bin/bash

# ------------
# MIT License
#
# Copyright (c) 2022 https://github.com/akippnn
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ------------

# Check if fresh install variable was passed
if [ -z ${REQ_FRESH_INSTALL+x} ] ; then
	REQ_FRESH_INSTALL=true
elif [ "${REQ_FRESH_INSTALL^^}" = true ] || [ "${REQ_FRESH_INSTALL^^}" = false ] ; then
	echo "REQ_FRESH_INSTALL only accepts true or false values"
	exit
fi


## INIT

NC='\033[0m' # No Color
MG='\033[0;35m' # Purple
CY='\033[0;36m' # Cyan
YL='\033[1;33m' # Yellow
sh_repo_url="${CY}https://github.com/akippnn/aurutilsinstaller$NC"
version="2"
prefix="${YL}[aurutilsinstaller ver. $version]$NC"
pkg="${MG}aurutils$NC"
pkg_url="${CY}https://aur.archlinux.org/packages/aurutils$NC"
git_url="https://aur.archlinux.org/aurutils.git"

# shellcheck disable=2089
__aurremove="#!/bin/sh --
	\n# aur-remove - remove listed packages from all local repositories
	\n
	\nif [ \"\$#\" -eq 0 ]; then
	\n	printf 'usage: aur remove package [package ...]\\\n' >&2
	\n	exit 1
	\nfi
	\n
	\naur repo --list-path | while read -r repo_path; do
	\nrepo-remove \"\$repo_path\" \"\$@\"
	\npaccache -c \"\${repo_path%/*}\" -rvk0 \"\$@\"
	\ndone"

__nonfresh="$prefix Warning: Do not use this script if you have a working aurutils install.
	\nAs for now, this script is only meant to be deployed on fresh systems with no trace of $pkg.
	\nPass the variable REQ_FRESH_INSTALL as false (case-insensitive) to ignore this warning.\n"
	
nonfresh () {
        if [ "$REQ_FRESH_INSTALL" = true ] ; then
                # shellcheck disable=2086
                echo -e $__nonfresh
                exit
        fi
	return 1
}

## Checks if the script is run in root
if ! [ "$EUID" -ne 0 ] ; then
	echo -e "$prefix Please do not run this script as root.\n"
	exit
## Checks if aurutils is in pacman
elif ! [[ $(pacman -Qi aurutils &> /dev/null) ]] ; then 
	nonfresh
fi



## INTRO

__intro="$prefix This script will download and install the package $pkg ($pkg_url) from the AUR.
	\nIt is recommended to deploy this only on fresh systems with no trace of $pkg.
	\nPlease see $sh_repo_url and $pkg_url for more details.\n"
# shellcheck disable=2086
echo -e $__intro
select input in "Download and Install" "Cancel" ; do
	case $input in
		"Download and Install" ) break;;
		"Cancel" ) exit;;
	esac
done

## Set up the repository
echo -e "\n$prefix Please answer the following:"
read -rp 'Enter your new repository name [default: custompkgs]: ' REPO_NAME
read -rp 'Where to place the repository [default: /home/custompkgs]: ' REPO_DIR
REPO_NAME=${REPO_NAME:-custompkgs}
REPO_DIR=${REPO_DIR:-/home/custompkgs}

echo -e "\nPlease pay attention to the terminal until the script is finished, it shouldn't take a while.\nAssuming you did not modify timestamp_timeout, password should mostly be asked once only."
sudo install -d "$REPO_DIR" -o "$USER"
if ! [ -d "$REPO_DIR" ] ; then
	echo -e "$prefix The repository directory the script was supposed to create does not exist. Please give a proper directory path."
	exit
fi
repo-add "$REPO_DIR"/"$REPO_NAME".db.tar.gz


## INSTALL
echo -e "$prefix Installing aurutils and its' dependencies"

## Git is a required to clone and is a dependency of aurutils (see pkg_url).
if [[ $(pacman -Qi git 1> /dev/null) ]] ; then
	sudo pacman -S git --asdeps --noconfirm
fi

# shellcheck disable=2164
git clone $git_url && cd "$(basename "$_" .git)" || nonfresh || cd aurutils || exit
if grep -Fx 'pkgname=aurutils' PKGBUILD 1> /dev/null ; then
	makepkg -si --noconfirm
else
	echo -e "$prefix Not sure what is going on here. You may want to troubleshoot."
	exit
fi


## FINALIZE
echo -e "$prefix Setting up the repository and adding aurutils"

mv aurutils*.pkg.tar* "$REPO_DIR"
repo-add -n custom.db.tar.gz aurutils*.pkg.tar*
sudo pacman -Syu


## CONFIGURE

__pacmanconf="
\n[$REPO_NAME]
\nSigLevel = Optional TrustAll
\nServer = file://$REPO_DIR"

echo -e "\n$prefix Installation finished. What else would you like to do?"
__options="1) Add repository $REPO_NAME to /etc/pacman.conf automatically
\n2) Sync vifm package and set vicmd (required to view build files)
\n3) Install aur-remove script (script from ${CY}man aur${NC})
\n4) Setup CacheDir and CleanMethod automatically (broken: will not add $REPO_NAME repository in CacheDir)
\n5) Quit"

while true ; do
        # shellcheck disable=2086
	echo -e $__options
	read -rp '#? ' input
	case $input in
		1 ) # shellcheck disable=2086
		    echo -e $__pacmanconf | sudo tee -a /etc/pacman.conf;
		    sudo pacman -Syu;
		    echo "Done.";;
		    
		2 ) sudo pacman -S vifm; 
		    read -rp "Set vicmd (leave blank to cancel): " VICMD;
		    if [ -n "$VICMD" ] ; then	
			    if ! [[ $(command -v "$VICMD") ]]  ; then
				    echo "$VICMD is not a command.";
				    continue;
			    fi;
			    sudo sed -i "s/set vicmd=.*/set vicmd=$VICMD/" "${XDG_CONFIG_HOME:-~/.config}"/vifm/vifmrc;
		    fi;;

		3 ) read -rp "Path to install the script [default: /usr/local/bin]" SCRIPT_DIR;
		    SCRIPT_DIR=${SCRIPT_DIR:-/usr/local/bin};
		    if [ -d "$SCRIPT_DIR" ] ; then
		            # shellcheck disable=2086,2090
			    echo -e $__aurremove | sudo tee "$SCRIPT_DIR"/aur-remove;
			    chmod +x "$SCRIPT_DIR"/aur-remove;
			    echo "Done.";
		    else
			    echo "$SCRIPT_DIR is not a directory.";
		    fi;;

		4 ) sudo sed -i "/^#CacheDir/s/$/ \"$REPO_DIR\"/" /etc/pacman.conf;
		    sudo sed -i "s/CleanMethod =.*/CleanMethod = KeepCurrent/" /etc/pacman.conf;
		    sudo sed -i "/\(CacheDir\|CleanMethod\)/s/^#//g" /etc/pacman.conf;
		    echo "Done.";;


	    	5 ) echo -e "$prefix Goodbye <3.";
		    break;;
	esac
done
