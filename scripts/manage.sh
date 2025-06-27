#!/bin/bash

####################################################
##                                                ##
##  Lazy man's script for managing Hetzner infra  ##
##  Used for downscaling and upscaling resources  ##
##  to save some costs. Not my best work.         ##
##                                                ##
##  Author: Svetoslav Petrov                      ##
####################################################

# Life is colorful, so should be scripts
BOLD="\033[1m"
GREEN="\033[32m"
ENDCOLOR="\033[0m"

# Keep track of the resources we create in this array
SERVERS=("vm-gitlab")

HCLOUD_BIN=$(which hcloud)

if [ -z $HCLOUD_BIN ]; then
  echo "hcloud binary not found"
  echo "Get the Hetzner CLI client by visiting https://github.com/hetznercloud/cli/blob/main/docs/tutorials/setup-hcloud-cli.md"
  exit 1
fi

help() {
  echo "Usage: $0 [command]"
  echo "Commands:"
  echo "  poweroff            Shut down all billable resources created by terraform"
  echo "  poweron             Start up all billable resources created by terraform"
}

get_hcloud_token() {
  HCLOUD_TOKEN=$(grep "hcloud_token" *.tfvars | cut -d'=' -f 2 | tr -d '"' | tr -d ' ')
  if [ -z $HCLOUD_TOKEN ]; then
    read -p "Enter hcloud token: " HCLOUD_TOKEN
  fi
}

get_servers_list() {
  server_list=$($HCLOUD_BIN server list -o noheader -o columns=ID,NAME,STATUS)
}

exec_server_command() {
  while IFS= read -r server; do
    server_id=$(awk -F ' ' '{print $1}' <<< $server)
    server_name=$(awk -F ' ' '{print $2}' <<< $server)
    server_status=$(awk -F ' ' '{print $3}' <<< $server)

    if [ $server_status == $want_state ]; then
      echo -e " ${GREEN}✓${ENDCOLOR} Server ${BOLD}${server_name}${ENDCOLOR} already $want_state (server ${server_id})"
      continue
    fi
    
    if [[ " ${SERVERS[*]} " =~ " ${server_name} " ]]; then
      $HCLOUD_BIN server $change_state_command $server_id
    fi
  done <<< "$server_list"
}

main() {
  get_hcloud_token
  get_servers_list
  case "$1" in
    poweroff)
      want_state="off"
      change_state_command="poweroff"
      exec_server_command
      ;;
    poweron)
      want_state="running"
      change_state_command="poweron"
      exec_server_command
      ;;
    *)
      help
      exit 1
      ;;
  esac
}

main "$@"