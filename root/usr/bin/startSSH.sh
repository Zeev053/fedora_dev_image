#!/bin/bash

echo "Should run with:"
echo "docker run --name dev-image -v c:\temp\.ssh:/temp -p 2025:22 zeevb053/fedora-dev:14.00"
echo 
echo "to add completion: kubectl completion bash > /etc/bash_completion.d/kubectl"

if [ -d "/temp" ] && [ -f "/temp/id_rsa" ] 
then
    echo "Copy /temp/id_rsa to ~/.ssh/."
    cp "/temp/id_rsa" ~/.ssh/
elif [ -d "/tmp" ] && [ -f "/tmp/id_rsa" ] 
then
    echo "Copy /tmp/id_rsa to ~/.ssh/."
    cp "/tmp/id_rsa" ~/.ssh/
else
    echo "Warning: file /tmp/id_rsa or /temp/id_rsa do not exists to access gitlab."
fi

rm -f ~/.ssh/id_rsa.pub

if [ -f ~/.ssh/id_rsa ] 
then
    echo 'chmod 600 ~/.ssh/id_rsa'
	chmod 600 ~/.ssh/id_rsa
fi

# Now start ssh.
/usr/sbin/sshd -D 

