#!/bin/bash

set -e

GITHUB_BASE_URL="https://raw.githubusercontent.com/OPKns/pterodactyl-uninstaller"
SCRIPT_VERSION="v0.8.0"


LOG_PATH="/var/log/pterodactyl-uninstaller.log"

# exit with error status code if user is not root
if [[ $EUID -ne 0 ]]; then
  echo "* This script must be executed with root privileges (sudo)." 1>&2
  exit 1
fi

# check for curl
if ! [ -x "$(command -v curl)" ]; then
  echo "* curl is required in order for this script to work."
  echo "* install using apt (Debian and derivatives)"
  exit 1
fi

output() {
  echo -e "* ${1}"
}

error() {
  COLOR_RED='\033[0;31m'
  COLOR_NC='\033[0m'

  echo ""
  echo -e "* ${COLOR_RED}ERROR${COLOR_NC}: $1"
  echo ""
}

execute() {
  echo -e "\n\n* pterodactyl-uninstaller $(date) \n\n" >>$LOG_PATH

  bash <(curl -s "$1") | tee -a $LOG_PATH
  [[ -n $2 ]] && execute "$2"
}

done=false

output "Pterodactyl uninstallation script @ $SCRIPT_VERSION"
output
output "Copyright (C) 2020 - 2022, OPKns, <contact@exaltairservices.ml>"
output "https://github.com/OPKNs/pterodactyl-uninstaller"
output
output "This script is not associated with the official Pterodactyl Project."

output

uninstall_panel(){
echo"panel";
}


uninstall_wings(){
echo"panel";
}

while true; do
    read -p "[1] Uninstall Panel
             [2] Uninstall Wings" 12
    case $12 in
        [1]* ) uninstall_panel; break;;
        [2]* ) uninstall_wings; break;;
        * ) echo "please answer 1 or 2";;
    esac
done
