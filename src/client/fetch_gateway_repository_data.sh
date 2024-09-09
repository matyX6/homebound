#!/bin/bash
source "$(dirname "$(realpath "$0")")/../shared.sh"

# Variables
LOCAL_REPO_PATH="$ROOT_DIRECTORY/sync_data"

printf "\nUpdating local files.\n"

# Fetch changes from the remote repository
git -C $LOCAL_REPO_PATH fetch origin

# Check if the fetch was successful
if [ $? -ne 0 ]; then
    printf "${RED}Failed to fetch data from the gateway repository. Make sure you set up git repository properly, or check your internet connection.\n${RESET}"
    exit 1
fi

# Force reset to the remote branch
git -C $LOCAL_REPO_PATH reset --hard origin/main

# Check if the reset was successful
if [ $? -eq 0 ]; then
    printf "${GREEN}Data was successfully synced from the gateway repository.\n${RESET}"
else
    printf "${RED}Failed to sync data from the gateway repository.\n${RESET}"
fi