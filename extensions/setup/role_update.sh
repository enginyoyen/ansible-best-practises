#!/bin/bash
set -e

COLOR_END='\e[0m'
COLOR_RED='\e[0;31m'

# This current directory.
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ROOT_DIR=$(cd "$DIR/../../" && pwd)
EXTERNAL_ROLE_DIR="$ROOT_DIR/roles/external"
ROLES_REQUIREMENTS_FILE="$ROOT_DIR/roles/roles_requirements.yml"
PYTHON_VIRTUALENV="$ROOT_DIR/.venv"

# Exit msg
msg_exit() {
    printf "$COLOR_RED$@$COLOR_END"
    printf "\n"
    printf "Exiting...\n"
    exit 1
}

# Trap if ansible-galaxy failed and warn user
cleanup() {
    msg_exit "Update failed. Please don't commit or push roles till you fix the issue"
}
trap "cleanup"  ERR INT TERM

# Check if python virtualenv has been setup
if [[ -d "$PYTHON_VIRTUALENV" ]]; then
  echo "Activating python virtual environment at '$PYTHON_VIRTUALENV'"
  source $PYTHON_VIRTUALENV/bin/activate
else
  msg_exit "Virtual Environment not created. Please run the setup.sh script before running this script."
fi

# Check ansible-galaxy
[[ -z "$(which ansible-galaxy)" ]] && msg_exit "Ansible is not installed or not in your path."

# Check roles req file
[[ ! -f "$ROLES_REQUIREMENTS_FILE" ]]  && msg_exit "roles_requirements '$ROLES_REQUIREMENTS_FILE' does not exist or permssion issue.\nPlease check and rerun."

# Remove existing roles
if [ -d "$EXTERNAL_ROLE_DIR" ]; then
    cd "$EXTERNAL_ROLE_DIR"
	if [ "$(pwd)" == "$EXTERNAL_ROLE_DIR" ];then
	  echo "Removing current roles in '$EXTERNAL_ROLE_DIR/*'"
	  rm -rf *
	else
	  msg_exit "Path error could not change dir to $EXTERNAL_ROLE_DIR"
	fi
fi



# Install roles
ansible-galaxy install -r "$ROLES_REQUIREMENTS_FILE" --force --no-deps -p "$EXTERNAL_ROLE_DIR"

exit 0
