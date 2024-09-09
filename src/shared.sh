#!/bin/bash

# Define terminal color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
MAGENTA='\033[0;35m'
GRAY='\033[38;5;240m'
LIGHT_GRAY='\033[38;5;250m'
RESET='\033[0m'

ROOT_DIRECTORY="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
SERVER_DATA_INI="$ROOT_DIRECTORY/sync_data/server_data.ini"

# Function to read the external IP address that is already written in local file
get_stored_external_ip() 
{
    read_ini_value "$SERVER_DATA_INI" "Network" "ExternalIp"
}

# Function to read the user that is already written in local file
get_stored_user() 
{
    read_ini_value "$SERVER_DATA_INI" "System" "User"
}

# Function to read the host that is already written in local file
get_stored_host() 
{
    read_ini_value "$SERVER_DATA_INI" "System" "Host"
}

get_stored_server_root_directory()
{
    read_ini_value "$SERVER_DATA_INI" "Software" "RootDirectory"
}

# Function to read a value from the INI file
read_ini_value() 
{
    local file=$1
    local section=$2
    local key=$3
    awk -F '=' -v section="$section" -v key="$key" '
    $0 ~ "\\[" section "\\]" { in_section=1; next }
    in_section && $1 == key { print $2; exit }
    $0 ~ "^\\[" { in_section=0 }
    ' "$file"
}

# Function to update a value in the INI file
update_ini_value() 
{
    local file=$1
    local section=$2
    local key=$3
    local value=$4
    sed -i.bak "/^\[$section\]/,/^\[/ s|^\($key=\).*|\1$value|" "$file" && rm "${file}.bak"
}