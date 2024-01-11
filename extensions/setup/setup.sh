#!/bin/bash
set -e

COLOR_END='\e[0m'
COLOR_RED='\e[0;31m' # Red
COLOR_YEL='\e[0;33m' # Yellow
# This current directory.
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ROOT_DIR=$(cd "$DIR/../../" && pwd)

PYTHON_REQUIREMENTS_FILE="$DIR/python_requirements.txt"
PYTHON_VIRTUALENV="$ROOT_DIR/.venv"

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
if ! command -v python3 &> /dev/null; then
    msg_exit "Python3 is not installed or is not in your path. Please install Python and try again"
fi
# Check virtualenvironment
if ! python3 -c "import venv" &> /dev/null; then
    msg_exit "Python3 venv module not installed. Please ensure that virtualenvironments are enabled and try again"
fi
# Check python requirements file
[[ ! -f "$PYTHON_REQUIREMENTS_FILE" ]]  && msg_exit "python_requirements '$PYTHON_REQUIREMENTS_FILE' does not exist or permssion issue.\nPlease check and rerun."

# Install 
# By default we upgrade all packges to latest. if we need to pin packages use the python_requirements
echo "This script install python packages defined in '$PYTHON_REQUIREMENTS_FILE' in the virtualenv at '$PYTHON_VIRTUALENV'"
echo "Creating virtualenvironment '$PYTHON_VIRTUALENV' if it does not already exist..."
python3 -m venv $PYTHON_VIRTUALENV
echo "Activating the virtualenvironment..."
source $PYTHON_VIRTUALENV/bin/activate
echo "Installing requirements..."
pip install --no-cache-dir  --upgrade --requirement "$PYTHON_REQUIREMENTS_FILE"


#Touch vpass
echo "Touching vpass"
if [ -w "$ROOT_DIR" ]
then
   touch "$ROOT_DIR/.vpass"
else
  sudo touch "$ROOT_DIR/.vpass"
fi
exit 0
