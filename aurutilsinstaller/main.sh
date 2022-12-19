#!/bin/bash
source variables.sh

exe() {
  # Echos the command used, https://stackoverflow.com/a/23342259
  # Note: Uses eval, please use sparingly and make sure commands are sanitized.
  if ! [[ ${*[0]} == "echo"]]; then {
    echo -e "${A_YL}\$${A_NC} $@"; 
    eval "$@";
  } fi
}

main() {
  if [[ "$(whoami)" == "root" ]]; then {
    echo -e "$prefix Please do not run this script as root.\n"
    exit
  elif [[ $(pacman -Qi aurutils &> /dev/null) ]]; then
    nonfresh
  } fi

  echo -e "
    ${A_YL}aurutilsinstaller ${A_CY}${version}${A_NY}
    A shell script to deploy aurutils scripts for Arch Linux systems
  "

  options=(
    "Setup aurutils and dependencies (git, vifm/vicmd)"
    "Scripts (aur-remove, aur-gc, ...)"
    "Repository management"
    "Quit"
    )
  ### wip section
  select input in $options; do {
    case ${input} in
      "Setup aurutils and dependencies (git, vifm.vicmd)" ) 
        break;;
      *)
        echo "Please select properly"
    esac
  } done
}

main
