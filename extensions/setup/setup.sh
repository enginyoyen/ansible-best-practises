#!/bin/bash
set -e
#TODO: Support python virtual environments for now global

COLOR_END='\e[0m'
COLOR_RED='\e[0;31m' # Red
COLOR_YEL='\e[0;33m' # Yellow
# This current directory.
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ROOT_DIR=$(cd "$DIR/../../" && pwd)

PYTHON_REQUIREMNTS_FILE="$DIR/python_requirements.txt"

msg_exit() {
    printf "$COLOR_RED$@$COLOR_END"
    printf "\n"
    printf "Exiting...\n"
    exit 1
}

msg_warning() {
    printf "$COLOR_YEL$@$COLOR_END"
    printf "\n"
}
# Check your environment 
system=$(uname)

if [ "$system" == "Linux" ]; then
    distro=$(lsb_release -i)
    if [[ $distro == *"Ubuntu"* ]] || [[ $distro == *"Debian"* ]] ;then
        msg_warning "Your running Debian based linux.\n You might need to install 'sudo apt-get install build-essential python-dev\n."
        # TODO: check if ubuntu and install build-essential, and python-dev
    else
        msg_warning "Your linux system was not test"
    fi
fi


# Check if root
# Since we need to make sure paths are okay we need to run as normal user he will use ansible
[[ "$(whoami)" == "root" ]] && msg_exit "Please run as a normal user not root"

# Check python
[[ -z "$(which python)" ]] && msg_exit "Opps python is not installed or not in your path."
# Check pip
[[ -z "$(which pip)" ]] && msg_exit "pip is not installed!\nYou can try'sudo easy_install pip'"
# Check python file
[[ ! -f "$PYTHON_REQUIREMNTS_FILE" ]]  && msg_exit "python_requirements '$PYTHON_REQUIREMNTS_FILE' does not exist or permssion issue.\nPlease check and rerun."

# Install 
# By default we upgrade all packges to latest. if we need to pin packages use the python_requirements
echo "This script install python packages defined in '$PYTHON_REQUIREMNTS_FILE' "
echo "Since we only support global packages installation for now we need root password."
echo "You will be asked for your password."
sudo -H pip install --no-cache-dir  --upgrade --requirement "$PYTHON_REQUIREMNTS_FILE"


#Touch vpass
echo "Touching vpass"
if [ -w "$ROOT_DIR" ]
then
   touch "$ROOT_DIR/.vpass"
else
  sudo touch "$ROOT_DIR/.vpass"
fi
exit 0
