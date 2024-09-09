#!/bin/bash

SCRIPT_DIRECTORY=$(dirname "$(realpath "$0")")
source "$SCRIPT_DIRECTORY/../shared.sh"

# Fetch, update data from gateway remote repository
bash "$SCRIPT_DIRECTORY/fetch_gateway_repository_data.sh"

# Connection data
externalIp=$(get_stored_external_ip)
user=$(get_stored_user)
host=$(get_stored_host)

# Try to connect to the local network
printf "\nAttempting to connect to the server on the local network...\n"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${user}@${host}

# If local connection fails, try to connect to the server remotely
if [ $? -ne 0 ]; then
    printf "\nAttempting to connect to the server remotely...\n"
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${user}@${externalIp}
fi