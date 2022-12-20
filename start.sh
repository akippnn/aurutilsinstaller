#!/bin/bash
if [[ pacman -Qi "perl" ]]; then {
  perl ./src/main.pl
} else {
  echo "Perl is not installed."
}

# Useful for future reference
# exe() {
#   # Echos the command used, https://stackoverflow.com/a/23342259 for inspiration.
#   # Note: Uses eval, please use sparingly and make sure commands are sanitized.
#   if ! [[ ${*[0]} == "echo"]]; then {
#     echo -e "${A_YL}\$${A_NC} $@"; 
#     eval "$@";
#   } fi
# }
