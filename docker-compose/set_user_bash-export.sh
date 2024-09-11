#!/bin/bash

echo Update RTD env for devlop with rt-docker image
echo to use in bash
export RTD_SSH_KEY_BASE64=$(base64 -w 0 ~/.ssh/id_rsa)
export RTD_USER_ID=$(id -u)
export RTD_FULL_NAME=$(getent passwd | grep $USER | cut -d ":" -f 5 | head -n 1)

echo
echo "  -> RTD_USER_ID: ${RTD_USER_ID}"
echo "  -> RTD_FULL_NAME: ${RTD_FULL_NAME}"

if [ ! -z ${RTD_SSH_KEY_BASE64} ]
then 
    echo '  -> RTD_SSH_KEY_BASE64: ** EXIST **'
fi

echo

