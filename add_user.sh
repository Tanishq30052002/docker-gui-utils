#!/bin/bash

# a bash script to automate adding a new user
# Author = Aniket Kumar Roy

REMOVE_SCRIPT=
NO_PASSWORD_REQUIRED=

PASSWORD=
USERNAME=
FULLNAME=
ROOMNO=
WORKPHN=
HOMEPHN=
OTHER=

position=1

_usage(){
  echo "$0 [-r|--remove] [-p|--password password] [--no_password_recommend] username [fullname] [roomno] [workphone] [homephone] [other]"
  echo "a script to automate the creating of a user and adding it to the sudo group"
  echo "-r(optional): removes this script after creating the user"
  echo "-p(optional):" provides the password beforehand so that the script will not later prompt you for password
  echo "--no_password_recommend(optional):" user can use sudo privileges without password, the script will not later prompt you for password
  echo "username(mandatory): username"
  echo "fullname(optional): full name of user"
  echo "roomno(optional): room no. of user"
  echo "workphone(optional): workphone no. of user"
  echo "homephone(optional): homephone no. of user"
  echo "other(optional): any other info. of user"
}

if [[ "${#}" == 0 ]]; then
  _usage
  exit 1
fi

# Parse options
while [[ "${#}" -gt 0 ]]; do
  case "${1}" in

    -h|-help|--help)
      _usage
      exit 0
      ;;

    -r|--remove)
      REMOVE_SCRIPT="true"
      shift 1
      ;;

    --no_password_recommend)
      NO_PASSWORD_REQUIRED="true"
      shift 1
      ;;

    -p|--password)
      if [[ -z "${NO_PASSWORD_REQUIRED}" ]]; then
        PASSWORD=${2}
        if [ -z "${PASSWORD}" ]; then
          _usage
          echo "-p|--password flag must be followed by a password"
          exit 1
        else
          shift 2
        fi
      fi
      ;;

    *)
      case "${position}" in
        1)
          USERNAME="${1}"
          position=2
          shift 1
          ;;

        2)
          FULLNAME="${1}"
          position=3
          shift 1
          ;;
        
        3)
          ROOMNO="${1}"
          position=4
          shift 1
          ;;
          
        4)
          WORKPHN="${1}"
          position=5
          shift 1
          ;;
          
        5)
          HOMEPHN="${1}"
          position=6
          shift 1
          ;;
          
        6)
          OTHER="${1}"
          position=7
          shift 1
          ;;
          
        7)
          _usage
          echo "unknown argument ${1}"
          exit 1
          break
          ;;
      esac

  esac
done


# Validate username
if [[ -z "${USERNAME}" ]]; then
  _usage
  echo "username is required"
  exit 1
fi

# Check if sudo is installed, and install it if not
if ! command -v sudo &> /dev/null; then
  echo "sudo not found, installing sudo..."
  apt-get update && apt-get install -y sudo
  if [ $? -ne 0 ]; then
    echo "Failed to install sudo. Exiting."
    exit 1
  fi
fi

# Disable history for the current shell
set +o history
# Re-enable history upon script exit
trap 'set -o history' EXIT

# If password is not provided through -p flag, prompt for it
if [[ -z "${PASSWORD}" || -z "${NO_PASSWORD_REQUIRED}" ]]; then
  passwd=
  read -sp "Enter password for ${USERNAME}: " passwd
  echo
  read -sp "Re-Enter password for ${USERNAME}: " PASSWORD
  echo

  if [[ "${passwd}" != "${PASSWORD}" ]]; then
    echo "password mismatched"
    exit 1
  fi
fi

# Create the user with no password and additional user information
adduser --disabled-password --gecos "$FULLNAME, $ROOMNO, $WORKPHN, $HOMEPHN, $OTHER" "$USERNAME" && \
# Set the user's password
echo "$USERNAME:$PASSWORD" | chpasswd && \
# Add the user to the sudo group
usermod -aG sudo "$USERNAME"

if [[ "${NO_PASSWORD_REQUIRED}" == "true" ]]; then
  echo "${USERNAME}" ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/"${USERNAME}" \
  && chmod 0440 /etc/sudoers.d/"${USERNAME}"
fi

# Move the script to the user's home directory
mv "$0" /home/"${USERNAME}"/

# Switch to the new user and change directory to their home
runuser -l "${USERNAME}" -c "cd /home/${USERNAME}"

# Remove the script if the -r flag was provided
if [ "$REMOVE_SCRIPT" = true ]; then
  rm -f /home/"${USERNAME}"/$(basename "$0")
fi
