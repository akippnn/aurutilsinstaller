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

if [ -z ${REQ_FRESH_INSTALL+x} ] ; then
	REQ_FRESH_INSTALL=true
elif [ ${REQ_FRESH_INSTALL^^} = true ] || [ ${REQ_FRESH_INSTALL^^} = false ] ; then
	echo "REQ_FRESH_INSTALL only accepts true or false values"
	exit
fi

## INIT

NC='\033[0m' # No Color
MG='\033[0;35m' # Purple
CY='\033[0;36m' # Cyan
YL='\033[1;33m' # Yellow
SH_REPO_URL="${CY}coming soon$NC"
VERSION="1.0.0"
PREFIX="${YL}[aurutilsinstaller $VERSION]$NC"
PKG="${MG}aurutils$NC"
PKG_URL="${CY}https://aur.archlinux.org/packages/aurutils$NC"
GIT_URL="https://aur.archlinux.org/aurutils.git"

__aurremove="#!/bin/sh --
\n# aur-remove - remove listed packages from all local repositories
\n
\nif [ "$#" -eq 0 ]; then
\n	printf 'usage: aur remove package [package ...]\n' >&2
\n	exit 1
\nfi
\n
\naur repo --list-path | while read -r repo_path; do
\nrepo-remove \"\$repo_path\" \"\$@\"
\npaccache -c \"\${repo_path%/*}\" -rvk0 \"\$@\"
\ndone"


__intro="$PREFIX This script will download and install the package $PKG ($PKG_URL) from the AUR.\n
It is recommended to deploy this only on fresh systems with no trace of $PKG.\n
Please see $SH_REPO_URL and $PKG_URL for more details.\n"
__nonfresh="$PREFIX Warning: Do not use this script if you have a working aurutils install.\n
As for now, this script is only meant to be deployed on fresh systems with no trace of $PKG.\n
Pass the variable REQ_FRESH_INSTALL as false (case-insensitive) to ignore this warning.\n"

# Checks if the script is run in root
if ! [ "$EUID" -ne 0 ] ; then
	printf "$PREFIX Please do not run this script as root.\n"
	exit
# Checks if aurutils is in pacman
elif [[ $(pacman -Qi aurutils &> /dev/null) ]] && [ $REQ_FRRSH_INSTALL = true ] ; then 
	echo -e $__nonfresh 
	exit
fi

## INTRO

echo -e $__intro
select input in "Download and Install" "Cancel" ; do
	case $input in
		"Download and Install" ) break;;
		"Cancel" ) exit;;
	esac
done

# Attempt to keep sudo invocation privileges
echo -e "\nPlease pay attention to the terminal until the script is finished, it shouldn't take a while.\nAssuming you did not modify timestamp_timeout, password should mostly be asked once only."
sudo echo ""

## INSTALL

# Git is a required dependency, for this script and for aurutils. See PKG_URL
if ! [[ $(pacman -Qi git 1> /dev/null) ]] ; then
	sudo pacman -S git --asdeps --noconfirm
fi

git clone $GIT_URL && cd "$(basename "$_" .git)"
if [ ! -f PKGBUILD ] ; then # If the previous command fails
	if [ -d "aurutils" ] ; then
		if [ $REQ_FRESH_INSTALL = true ] ; then
			echo -e $__nonfresh
			exit
		else
			cd aurutils
		fi
	else
		echo -e "$PREFIX Not sure what is going on here. You may want to troubleshoot your system, or change directory to a file location where you have write access."
		exit
	fi
fi
makepkg -si --noconfirm

## FINALIZE

printf "$PREFIX Please answer the following:\n"
read -p 'Enter your new repository name [default: custompkgs]: ' REPO_NAME
read -p 'Where to place the repository [default: /home/custompkgs]: ' REPO_DIR
REPO_NAME=${REPO_NAME:-custompkgs}
REPO_DIR=${REPO_DIR:-/home/custompkgs}

sudo install -d $REPO_DIR -o $USER
repo-add $REPO_DIR/$REPO_NAME.db.tar.gz
mv aurutils*.pkg.tar* $REPODIR
repo-add -n custom.db.tar.gz aurutils*.pkg.tar*
sudo pacman -Syu

__pacmanconf="
\n[$REPO_NAME]
\nSigLevel = Optional TrustAll
\nServer = file:/$REPO_DIR"

__pathwithbackslash=sed 's#/#\\/#g' $REPO_DIR

echo -e "$PREFIX Installation finished. What else would you like to do?"
__options="1) Add repository $REPO_NAME to /etc/pacman.conf automatically
\n2) Install aur-remove script
\n3) Setup CacheDir and CleanMethod automatically (hacky as of now, may only partially work)
\n4) Quit"
while true; do
	echo -e $__options
	read -p '#? ' ans
	case $ans in
		1 ) echo -e $__pacmanconf | sudo tee -a /etc/pacman.conf;
		    sudo pacman -Syu;
		    echo "Done.";;
		2 ) echo -e $__aurremove | sudo tee /usr/local/bin/aur-remove;
		    echo "Done.";;
		3 ) sudo sed -i "/^#CacheDir/s/$/ $__pathwithbackslash/" /etc/pacman.conf;
		    sudo sed -i "s/CleanMethod =.*/CleanMethod = KeepCurrent/" /etc/pacman.conf;
		    sudo sed -i "/\(CacheDir\|CleanMethod\)/s/^#//g" /etc/pacman.conf;
		    echo "Done.";;
	    	4 ) echo -e "$PREFIX Goodbye <3."; break;;
	esac
done
