#!/bin/bash

SCRIPT_DIRECTORY=$(dirname "$(realpath "$0")")
source "$SCRIPT_DIRECTORY/../shared.sh"

# Variables
SERVER_CONFIG_INI_FILE="$SCRIPT_DIRECTORY/config.ini"
TICK_INTERVAL_SECONDS=$(read_ini_value "$SERVER_CONFIG_INI_FILE" "Timing" "TickIntervalSeconds")
retry_gateway_update=false

# Function to calculate future time and print the message
print_next_external_ip_check_time() 
{
  local seconds_left=$1
  local hours=$((seconds_left / 3600))
  local minutes=$(( (seconds_left % 3600) / 60 ))
  local seconds=$((seconds_left % 60))

  local time_str=""
  if [ $hours -gt 0 ]; then
    time_str="${hours}h "
  fi
  if [ $minutes -gt 0 ] || [ $hours -gt 0 ]; then
    time_str="${time_str}${minutes}m "
  fi
  time_str="${time_str}${seconds}s"

  # Try both parsing commands... date -v will work on BSD macos, date -d will work on GNU Linux/Windows
  local future_time=$(date -v +${seconds_left}S +%H:%M:%S 2>/dev/null || date -d "+${seconds_left} seconds" +%H:%M:%S)
  printf "${GRAY}\n\nNext server data check in ${LIGHT_GRAY}${time_str}${GRAY} at ${LIGHT_GRAY}${future_time} ${GRAY}system time.${RESET}"
}

# Function that handles cooldown before code re-iteration
tick_cooldown()
{
  local seconds_left=$1
  print_next_external_ip_check_time $seconds_left
  while [ "$seconds_left" -gt 0 ]; do
    sleep 1 # sleep for a second
    ((seconds_left--))
  done
}

printf "${GREEN}\nServer started on $(date)${RESET}\n"

while true
do  
  # Check for a network external ip change
  bash "$SCRIPT_DIRECTORY/check_for_server_data_change.sh"
  
  # Push changes to gateway repository if network external ip has changed or if the previous push failed
  if [ $? -eq 0 ] || [ "$retry_gateway_update" = true ]; then
    
      # Send updates to gateway repository
      bash "$SCRIPT_DIRECTORY/send_updates_to_gateway_repository.sh"
      
      # Set the retry update flag if gateway repository update failed
      if [ $? -eq 0 ]; then
          retry_gateway_update=false
      else
          retry_gateway_update=true
      fi
  fi
  
  # Wait for cooldown to pass
  tick_cooldown $TICK_INTERVAL_SECONDS
done
