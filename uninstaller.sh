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

PANEL_UNINSTALLER="$GITHUB_BASE_URL/main/install-panel.sh"

WINGS_UNINSTALLER="$GITHUB_BASE_URL/main/install-wings.sh"


while [ "$done" == false ]; do
  options=(
    "Uninstall the panel"
    "Uninstall Wings"
    "Uninstall both [0] and [1] on the same machine (wings Uninstall script runs after panel)\n"

  )

  actions=(
    "$PANEL_UNINSTALLER"
    "$WINGS_UNINSTALLER"
    "$PANEL_UNINSTALLERT;$WINGS_UNINSTALLER"
  )

  output "What would you like to do?"

  for i in "${!options[@]}"; do
    output "[$i] ${options[$i]}"
  done

  echo -n "* Input 0-$((${#actions[@]} - 1)): "
  read -r action

  [ -z "$action" ] && error "Input is required" && continue

  valid_input=("$(for ((i = 0; i <= ${#actions[@]} - 1; i += 1)); do echo "${i}"; done)")
  [[ ! " ${valid_input[*]} " =~ ${action} ]] && error "Invalid option"
  [[ " ${valid_input[*]} " =~ ${action} ]] && done=true && IFS=";" read -r i1 i2 <<<"${actions[$action]}" && execute "$i1" "$i2"
done
