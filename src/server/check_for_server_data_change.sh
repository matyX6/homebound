#!/bin/bash
source "$(dirname "$(realpath "$0")")/../shared.sh"

# Variables
server_data_changed=false

# Function to check and update values if they changed
check_and_update_values() 
{
    local current_value=$1
    local stored_value=$2
    local section=$3
    local key=$4
    local debug_message=$5


    if [ "$current_value" != "$stored_value" ]; then
        update_ini_value "$SERVER_DATA_INI" "$section" "$key" "$current_value"
        server_data_changed=true
        printf "$debug_message ${MAGENTA} CHANGED ${RESET}"
    else
        printf "$debug_message ${YELLOW} NOT CHANGED ${RESET}"
    fi
}

# Function to read the external IP
get_network_external_ip() 
{
    curl -s http://ifconfig.me
}

resolve_external_ip()
{
  # Get the current external and stored IPs
  network_external_ip=$(get_network_external_ip)
  stored_external_ip=$(get_stored_external_ip)
  
  # Check if the external IP was obtained successfully, early exit if not
  if [ -z "$network_external_ip" ]; then
      printf "${RED}\nFailed to obtain an External IP. It's your internet connection or service (http://ifconfig.me) may be down.${RESET}"
      exit 1
  fi
  
  # Update the INI file if the IP has changed
  check_and_update_values "$network_external_ip" "$stored_external_ip" "Network" "ExternalIp" "\nExternal IP: $network_external_ip ${GRAY} Stored External IP: $stored_external_ip${RESET}"
}

resolve_user()
{
  # Get the username on Unix, if it fails try Windows commands
  user=$(whoami 2>/dev/null || echo $USERNAME)
  stored_user=$(get_stored_user)
  check_and_update_values "$user" "$stored_user" "System" "User" "\nUser: $user ${GRAY} Stored User: $stored_user${RESET}"
}

resolve_host()
{
  # Get the hostname on Unix, if it fails try Windows commands
  host=$(hostname 2>/dev/null || echo $COMPUTERNAME)
  stored_host=$(get_stored_host)
  check_and_update_values "$host" "$stored_host" "System" "Host" "\nHost: $host ${GRAY} Stored Host: $stored_host${RESET}"
}

resolve_root_directory()
{
   # Get the server's root directory
    root_directory=$ROOT_DIRECTORY
    stored_root_directory=$(get_stored_server_root_directory)
    check_and_update_values "$root_directory" "$stored_root_directory" "Software" "RootDirectory" "\nRoot directory: $root_directory ${GRAY} Stored root directory: $stored_root_directory${RESET}"
}

printf "${GRAY}\nChecking for a server data change...${RESET}"

resolve_external_ip
resolve_user
resolve_host
resolve_root_directory

if [ "$server_data_changed" = true ]; then
    printf "${MAGENTA}\nServer data has changed on $(date).${RESET}"
    update_ini_value "$SERVER_DATA_INI" "Other" "LastUpdateTime" "$(date)"
    exit 0
else
    printf "${YELLOW}\nServer data has not changed.${RESET}"
    exit 1
fi