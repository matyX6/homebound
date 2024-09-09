#!/bin/bash
source "$(dirname "$(realpath "$0")")/../shared.sh"

# Variables
LOCAL_REPO_PATH="$ROOT_DIRECTORY/sync_data"

printf "\n\nUpdating gateway repository.\n"

# Staging the specified file
git -C $LOCAL_REPO_PATH add $SERVER_DATA_INI

# Discarding changes in all other files
git -C $LOCAL_REPO_PATH checkout -- .

# Committing the staged file
git -C $LOCAL_REPO_PATH commit -m "Temporary auto-squash commit"

# Squashing the commit into the parent commit
git -C $LOCAL_REPO_PATH reset --soft HEAD~1

# Amending the commit with the new date, author name, email, and commit message
git -C $LOCAL_REPO_PATH commit --amend -m "Server data update" --date "$(date)" --author="homebound <none>"

# Setting the upstream branch and pushing to the remote repository
git -C $LOCAL_REPO_PATH push -u origin main --force

# Check if the push was successful
if [ $? -eq 0 ]; then
    printf "${GREEN}Successfully updated the gateway repository.${RESET}"
    exit 0
fi

# Fail message
printf "${RED}Failed to update the gateway repository. Update will retry on the next server iteration.${RESET}"
exit 1
