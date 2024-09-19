#!/bin/bash

# RTD_SSH_KEY_BASE64=$(base64 -w 0 id_rsa)
# in csh: setenv RTD_SSH_KEY_BASE64 `base64 -w 0 ~/.ssh/id_rsa`
# in csh: setenv RTD_USER_ID `id -u`
# in csh: setenv RTD_FULL_NAME `getent passwd | grep $USER | cut -d ":" -f 5 | head -n 1`
# echo ${RTD_SSH_KEY_BASE64} | base64 -d > id_rsa
usage()
{
    echo "Linux Machine"
    echo "--------------------------------------"
    echo "In order to run the developing image in LINUX machine that require different scheduler,"
    echo "the docker service should run with the following command:"
    echo "ExecStart=/usr/bin/dockerd --cpu-rt-runtime=950000 --cpu-rt-period=1000000 -H fd:// --containerd=/run/containerd/containerd.sock"
    echo "Update the file: /usr/lib/systemd/system/docker.service,"
    echo "and then start docker service with the commands:"
    echo "systemctl daemon-reload"
    echo "systemctl restart docker"
    echo "(this container can't run on Windows machine)"
    echo 
    echo "To run the container use the following command:"
    echo "docker run --rm --name rt_dev -it --shm-size=2G --privileged --network host --cpu-rt-runtime=200000 --ulimit rtprio=99 -v ~/my_docker.json:/temp/my_docker.json [image-name] -f /temp/my_docker.json"
    echo
    echo "If the container can run ordinarily, run the following command:"
    echo "docker run --rm --name rt_dev -it --privileged --network host -v ~/my_docker.json:/temp/my_docker.json  [image-name] -f /temp/my_docker.json"

    echo
    echo "Windows Machine"
    echo "--------------------------------------"
    echo "First, copy my_docker.json to /temp/my_docker.json"
    echo "The conatainer should start with following command:"
    echo "docker run --rm -it --name rt_dev --privileged -p 2025:2025 -v c:\temp\my_docker.json:/temp/my_docker.json [image-name] -f /temp/my_docker.json"
    echo 
    echo 
    echo 
    echo "my_docker.json file"
    echo "--------------------------------------"
    echo "This file contain your information in order to start the container with your credentials"
    echo "The file should exist in: ~/my_docker.json "
    echo "The file should look like the following lines:"
    echo "{"
    echo "  full_name": "[Your full name - like in outlook]",
    echo "  user_name": "[Your username]",
    echo "  user_id": "[Your user id in linux]",
    echo "  user_g_id": "[Your primary group id in linux]",
    echo "  user_g_name": "[Your primary group name in linux]",
    echo "  user_password": "[Should be empty]",
    echo "  user_shell": "/usr/bin/tcsh",
    echo "  mount_direcotry": "[Location of your home directory]",
    echo "  ssh_port": "2025"
    echo "}"
    
}

pass_fun=""
enter_password()
{
    pass_fun=""
    prompt="$1:"
    while IFS= read -p "$prompt" -r -s -n 1 char
    do
        if [[ $char == $'\0' ]]
        then
            break
        fi
		if [[ $char == $'\b' ]] || [[ $char == $'\177' ]]
		then
			[[ ! -z "$pass_fun" ]] && prompt=$'\b \b' || prompt=''
			pass_fun="${pass_fun%?}"
		else
			prompt='*'
			pass_fun+="$char"
		fi
    done
    echo
}

ssh_port=22
while getopts "hf:" opt ; do
    case "$opt" in
    h) # setup file
        usage
        exit 0
        ;;

    f) # setup file
        user_file=${OPTARG}
        echo "user_file: ${user_file}"
        if [ -f "${user_file}" ] 
        then
            echo "the file ${user_file} exist. parsing the file:"
            user_file_exist=true
            full_name=$(             cat ${user_file} | jq -r  ".full_name")
            user_name=$(             cat ${user_file} | jq -r  ".user_name")
            user_id=$(               cat ${user_file} | jq -r  ".user_id")
            user_g_id=$(             cat ${user_file} | jq -r  ".user_g_id")
            user_g_name=$(           cat ${user_file} | jq -r  ".user_g_name")
            user_password=$(         cat ${user_file} | jq -r  ".user_password" | sed s/null//)
            user_gitlab_token=$(     cat ${user_file} | jq -r  ".user_gitlab_token" | sed s/null//)
            user_shell=$(            cat ${user_file} | jq -r  ".user_shell")
            mount_direcotry=$(       cat ${user_file} | jq -r  ".mount_direcotry")
            mount_to_folder=$(       cat ${user_file} | jq -r  ".mount_to_folder")
            ssh_key_file_location=$( cat ${user_file} | jq -r  ".ssh_key_file_location" | sed s/null//)
            ssh_port=$(              cat ${user_file} | jq -r  ".ssh_port")
            
            echo "The following data read from ${user_file}"
            echo "full_name:             ${full_name}"
            echo "user_name:             ${user_name}"
            echo "user_id:               ${user_id}"
            echo "user_g_id:             ${user_g_id}"
            echo "user_g_name:           ${user_g_name}"
        #   echo "user_password:  ${user_password}  DELETE IT"
            echo "user_shell:            ${user_shell}"
            echo "mount_direcotry:       ${mount_direcotry}"
            echo "mount_to_folder:       ${mount_to_folder}"
            echo "ssh_key_file_location: ${ssh_key_file_location}"
            echo "ssh_port:              ${ssh_port}"
        else
            echo "the file ${user_file} not exist"
            user_file_exist=false
        fi
        ;;
    esac
done

# Take user information from enviroment variables:
# full_name: RTD_FULL_NAME
# user_name: RTD_USER_NAME
# user_id: RTD_USER_ID
# user_g_id: RTD_USER_G_ID
# user_g_name: RTD_USER_G_NAME
# user_password: RTD_USER_PASSWORD_BASE64
# user_gitlab_token: RTD_USER_GITLAB_TOKEN_BASE64
# user_shell: RTD_USER_SHELL
# mount_direcotry: RTD_MOUNT_DIRECOTRY
# mount_to_folder: RTD_MOUNT_TO_FOLDER
# ssh_key_file_location: RTD_SSH_KEY_BASE64
# ssh_port: RTD_SSH_PORT
# *** RTD_USER_PASSWORD_SHOULD_NOT_EXIST ***
# *** RTD_USER_GITLAB_TOKEN_SHOULD_EXIST ***
# *** RTD_INSTALL_VSCODE_SERVER ***

echo
echo _______________________________________
echo
echo env of RTD_:
echo _______________________________________
echo RTD_FULL_NAME: $RTD_FULL_NAME
echo RTD_USER_NAME: $RTD_USER_NAME
echo RTD_USER_ID: $RTD_USER_ID
echo RTD_USER_G_ID: $RTD_USER_G_ID
echo RTD_USER_G_NAME: $RTD_USER_G_NAME
#echo RTD_USER_PASSWORD_BASE64: $RTD_USER_PASSWORD_BASE64
#echo RTD_USER_GITLAB_TOKEN_BASE64: $RTD_USER_GITLAB_TOKEN_BASE64
echo RTD_USER_SHELL: $RTD_USER_SHELL
echo RTD_MOUNT_DIRECOTRY: $RTD_MOUNT_DIRECOTRY
echo RTD_MOUNT_TO_FOLDER: $RTD_MOUNT_TO_FOLDER
# echo RTD_SSH_KEY_BASE64: $RTD_SSH_KEY_BASE64
echo RTD_INSTALL_VSCODE_SERVER: $RTD_INSTALL_VSCODE_SERVER
echo RTD_SSH_PORT: $RTD_SSH_PORT
echo RTD_USER_PASSWORD_SHOULD_NOT_EXIST: $RTD_USER_PASSWORD_SHOULD_NOT_EXIST
echo RTD_USER_GITLAB_TOKEN_SHOULD_EXIST: $RTD_USER_GITLAB_TOKEN_SHOULD_EXIST

echo
echo _______________________________________
echo
if [ ! -z ${RTD_USER_PASSWORD_BASE64} ]
then 
    echo 'RTD_USER_PASSWORD_BASE64: ** EXIST **'
fi

if [ ! -z ${RTD_USER_GITLAB_TOKEN_BASE64} ]
then 
    echo 'RTD_USER_GITLAB_TOKEN_BASE64: ** EXIST **'
fi

if [ ! -z ${RTD_SSH_KEY_BASE64} ]
then 
    echo 'RTD_SSH_KEY_BASE64: ** EXIST **'
fi

echo _______________________________________
echo


echo Take user name from environment variable 
echo "if it didn't read from file"

if [ ! -z ${RTD_USER_NAME} ]
then
    echo take user_name from env RTD_USER_NAME
    user_name=$RTD_USER_NAME
    echo "user_name: ${user_name}"
    echo
fi

if [ ! -z "${RTD_FULL_NAME}" ]
then
    echo take full_name from env RTD_FULL_NAME
    full_name=$RTD_FULL_NAME
    echo "full_name: ${full_name}"
    echo
fi

if [ ! -z "${RTD_USER_ID}" ]
then
    echo take user_id from env RTD_USER_ID
    user_id=$RTD_USER_ID
    echo "user_id: ${user_id}"
    echo
fi

if [ ! -z "${RTD_USER_G_ID}" ]
then
    echo take user_g_id from env RTD_USER_G_ID
    user_g_id=$RTD_USER_G_ID
    echo "user_g_id: ${user_g_id}"
    echo
fi

if [ ! -z "${RTD_USER_G_NAME}" ]
then
    echo take user_g_name from env RTD_USER_G_NAME
    user_g_name=$RTD_USER_G_NAME
    echo "user_g_name: ${user_g_name}"
    echo
fi

if [ ! -z "${RTD_USER_SHELL}" ]
then
    echo Update user_shell to value of RTD_USER_SHELL: $RTD_USER_SHELL
    user_shell=${RTD_USER_SHELL}
    echo "user_shell: ${user_shell}"
fi

if [ ! -z "${RTD_MOUNT_DIRECOTRY}" ]
then
    echo Update mount_direcotry to value of RTD_MOUNT_DIRECOTRY: $RTD_MOUNT_DIRECOTRY
    mount_direcotry=${RTD_MOUNT_DIRECOTRY}
    echo "mount_direcotry: ${mount_direcotry}"
fi

if [ ! -z "${RTD_MOUNT_TO_FOLDER}" ]
then
    echo Update mount_to_folder to value of RTD_MOUNT_TO_FOLDER: $RTD_MOUNT_TO_FOLDER
    mount_to_folder=${RTD_MOUNT_TO_FOLDER}
    echo "mount_to_folder: ${mount_to_folder}"
fi

if [ ! -z "${RTD_SSH_PORT}" ]
then
    echo Update ssh_port to value of RTD_SSH_PORT: $RTD_SSH_PORT
    ssh_port=${RTD_SSH_PORT}
    echo "ssh_port: ${ssh_port}"
fi


# check if the user already exist
getent passwd $user_name > /dev/null
is_user_not_found=($?)

# if [ user_file_exist==true ] && [ $is_user_not_found -ne 0 ]
# If user is not already exist - continue
if [ $is_user_not_found -ne 0 ] 
then
    # Check if password should exist for the new user
    if [ "${RTD_USER_PASSWORD_SHOULD_NOT_EXIST}" != true ] 
    then
        # If user password didn't read from file, take it from env
        if [ -z ${user_password} ] && [ ! -z ${RTD_USER_PASSWORD_BASE64} ]
        then 
            echo Try take password from env RTD_USER_PASSWORD_BASE64
            user_password=$(echo ${RTD_USER_PASSWORD_BASE64} | base64 -d)
        fi

        # If user password didn't taken from env too, 
        # take the password from user:
        if [ -z ${user_password} ] 
        then 
            enter_password "Please type your password"
            user_password=$pass_fun
        fi
    else

        echo Currently do not touch the PermitRootLogin

        # PermitRootLogin prohibit-password
        # PasswordAuthentication no
        # echo Update ssh to disable password authentication to root:
        # sed -i 's/PermitRootLogin .*$/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
        # sed -i 's/PasswordAuthentication *.$/PasswordAuthentication no/' /etc/ssh/sshd_config

    fi

	echo

    # Take token from user if it doesn't exist, and it should exist
    if [ "${RTD_USER_GITLAB_TOKEN_SHOULD_EXIST}" == true ] && [ -z "${user_gitlab_token}" ]
    then

        # If user user_gitlab_token didn't read from file, take it from env
        if [ -z ${user_gitlab_token} ] && [ ! -z ${RTD_USER_GITLAB_TOKEN_BASE64} ]
        then 
            echo Try take password from env RTD_USER_GITLAB_TOKEN_BASE64
            user_gitlab_token=$(echo ${RTD_USER_GITLAB_TOKEN_BASE64} | base64 -d)
        fi

        # If user user_gitlab_token didn't taken from env too, 
        # take the user_gitlab_token from user:
        if [ -z ${user_gitlab_token} ] 
        then 
            enter_password "Please enter your gitlab api token"
            user_gitlab_token=$pass_fun
        fi
    fi
    echo

    echo "Check if to mount (mount_direcotry and mount_to_folder should not be empty):"
    if [ ! -z "${mount_direcotry}" ] && [ ! -z "${mount_to_folder}" ]
    then 
        echo Start mount:
        echo connect to ${mount_direcotry}, and mount it to folder: ${mount_to_folder}
        mkdir -p ${mount_to_folder}
        umount ${mount_to_folder}
        chmod 777 ${mount_to_folder}
        mount -t cifs  ${mount_direcotry} ${mount_to_folder} -o username=${user_name},noserverino,password=${user_password},domain=tbd
        if [ $? != "0" ]
        then
            echo mount to ${mount_direcotry} - FAILED; 
            echo last 8 lines of dmesg:
            sudo dmesg | tail -8
        fi
    fi

    echo
    echo Check if user id already exist and delete it
    if [[ $(getent passwd ${user_id}) ]]; then
        echo "The user id of the user: ${user_name} already exist, delete it (current user name: $(id -un $user_id))"
        userdel -f $(id -un $user_id)
    fi

    echo
    echo Check if user already exist and delete it
    if [[ $(getent passwd ${user_name}) ]]; then
        echo "The user name: ${user_name} already exist, delete it"
        userdel -f ${user_name}
    fi

    echo
    echo Check if group already exist and delete it
    if [[ $(getent group ${user_g_name}) ]]; then
        echo "The group name the group: ${user_g_name} already exist, delete it"
        groupdel -f ${user_g_name}
    fi

    echo
    echo Check if group id already exist and delete it
    if [[ $(getent group ${user_g_id}) ]]; then
        echo "The group id of the group: ${user_g_name} already exist, delete it (current user name: $(getent group $user_g_name | cut -d: -f1)" 
        groupdel -f $(getent group $user_g_name | cut -d: -f1)
    fi

    echo
    echo Create new group ${user_g_name}
	groupadd -g ${user_g_id} ${user_g_name}
    echo 
    echo Create new user ${user_name}
   	useradd -u ${user_id} -g ${user_g_name} -G wheel,${user_g_name} -ms ${user_shell} ${user_name}
    echo "AllowUsers root ${user_name}"  >> /etc/ssh/sshd_config 
    echo

	# check if to use gitlab token instead of ssh for git commands
    if [ "${RTD_USER_GITLAB_TOKEN_SHOULD_EXIST}" == true ] && [ ! -z "${user_gitlab_token}" ]
    then
		echo Using gitlab token
		echo "[url \"http://oauth2:${user_gitlab_token}@gitlab.tbd\"]" >> /etc/gitconfig
		echo "insteadOf = ssh://git@gitlab.tbd:122" >> /etc/gitconfig
    fi
    
    
	# check if to use ssh key
	if [ ! -z "${ssh_key_file_location}" ] || [ ! -z ${RTD_SSH_KEY_BASE64} ]
	then
		mkdir -p /home/${user_name}/.ssh/
		cd /home/${user_name}/.ssh/

        if [ ! -z ${RTD_SSH_KEY_BASE64} ]
        then 
            echo Take ssh key from env RTD_SSH_KEY_BASE64
            echo ${RTD_SSH_KEY_BASE64} | base64 -d > /home/${user_name}/.ssh/id_rsa
        else
            echo Take ssh key from file field ssh_key_file_location
            echo ls -l of ssh key to copy:
            ls -l ${ssh_key_file_location}
            cp -f ${ssh_key_file_location} /home/${user_name}/.ssh/id_rsa
        fi
        
        # Update permission to ssh key
		chmod 600 /home/${user_name}/.ssh/id_rsa
        chown ${user_name}:${user_g_name} /home/${user_name}/.ssh/id_rsa
        # Create ssh public key from private key
        ssh-keygen -f id_rsa -y > /home/${user_name}/.ssh/id_rsa.pub
        # Updte public key to authorized_keys in order to use ssh session with ssh key
        cat id_rsa.pub > /home/${user_name}/.ssh/authorized_keys
        
        ssh-keyscan -t rsa -p 122 gitlab.tbd > /home/${user_name}/.ssh/known_hosts
        echo "chown ${user_name}:${user_g_name} /home/${user_name}/.ssh/id_rsa"
        chown ${user_name}:${user_g_name} /home/${user_name}/.ssh/known_hosts
        chown -R ${user_name}:${user_g_name} /home/${user_name}/.ssh

		# copy to root
		sudo cp -f /home/${user_name}/.ssh/id_rsa /root/.ssh/id_rsa
		sudo cp -f /home/${user_name}/.ssh/id_rsa.pub /root/.ssh/id_rsa.pub
		sudo cp -f /home/${user_name}/.ssh/authorized_keys /root/.ssh/authorized_keys
		sudo chown root:root /root/.ssh/id_rsa
		sudo chown root:root /root/.ssh/id_rsa.pub
		sudo chown root:root /root/.ssh/authorized_keys
		sudo chmod 600 /root/.ssh/id_rsa
	fi
    
    echo 
    
    echo Update cshrc file
    echo "alias ll 'ls -lah'" > /home/${user_name}/.cshrc  
    echo "set -f path=("." \$path:q)" >> /home/${user_name}/.cshrc  
    chown ${user_name}:${user_g_name} /home/${user_name}/.cshrc
    echo 
    echo Update permission to user in sudoers file
    echo "${user_name} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

    if [ "${RTD_USER_PASSWORD_SHOULD_NOT_EXIST}" != true ] 
    then
        echo Update password to the new user and to root
        echo "${user_name}:${user_password}" | chpasswd
        echo "root:${user_password}" | chpasswd
    fi
    echo 
    echo Update git name and email
    git_name="${full_name}"
    git_email="${user_name}"@tbd
    if [ -z "${full_name}" ]
    then 
        echo full_name dont exist in input file.
        echo Use user name as full name for git:
        git_name=${user_name}
    fi
    git config --system user.name "${git_name}"
    git config --system user.email "${git_email}"
    
    # Check if to install vscode server:
    if [ "${RTD_INSTALL_VSCODE_SERVER}" == true ]
    then
        echo Install vscode-server to user $user_name
        # Find user home:
        user_home=$(getent passwd ${user_name} | cut -d: -f6)
        cd $user_home
        wget tbd
        tar -zxf vscode-server.tar.gz
        rm -f vscode-server.tar.gz
        chown -R $user_name:$user_g_name .vscode-server
        chmod -R 777 .vscode-server
    fi
fi

if [ -e /bin/extend_start.sh ]
then
    /bin/extend_start.sh "${is_user_not_found}" "${user_name}"
fi

# Now start ssh.
echo "Start ssh in port ${ssh_port}"
/usr/sbin/sshd -p ${ssh_port} -D

