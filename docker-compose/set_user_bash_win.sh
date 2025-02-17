#!/bin/bash

if [[ "$(uname -s)" == "Linux" ]]; then
    echo "Running on Linux"
	export RTD_FULL_NAME=$(getent passwd | grep $USER | cut -d ":" -f 5 | head -n 1)
elif [[ "$(uname -s)" == "MINGW64_NT"* || "$(uname -s)" == "MSYS_NT"* ]]; then
    echo "Running on Git Bash (Windows)"
	export USER=$USERNAME
	export RTD_FULL_NAME=$(wmic useraccount where name="'$USERNAME'" get fullname | sed -n '2p' | xargs)
else
    echo "Unknown environment"
	exit 1
fi

echo Update RTD env for devlop with rt-docker image
echo to use in bash
export RTD_SSH_KEY_BASE64=$(base64 -w 0 ~/.ssh/id_rsa)
export RTD_USER_ID=$(id -u)
export RTD_USER_G_ID=$(id -g)
export RTD_USER_G_NAME=tester

echo
echo "  -> RTD_USER_ID: ${RTD_USER_ID}"
echo "  -> RTD_FULL_NAME: ${RTD_FULL_NAME}"
echo "  -> RTD_USER_G_ID: ${RTD_USER_G_ID}"
echo "  -> RTD_USER_G_NAME: ${RTD_USER_G_NAME}"

if [ ! -z ${RTD_SSH_KEY_BASE64} ]
then
    echo '  -> RTD_SSH_KEY_BASE64: ** EXIST **'
fi

echo

