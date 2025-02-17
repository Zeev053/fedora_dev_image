#!/bin/bash -x

# run docker compose with update of enviroments

app_ip=$(hostname | sed -rn 's/.*(128[[:digit:]]*\.[[:digit:]]*\.[[:digit:]]*\.[[:digit:]]*).*/\1/p')
compose_file="compose.yml"

if [[ "$(uname -s)" == "Linux" ]]; then
    echo "Running on Linux"
	source set_user_bash.sh
elif [[ "$(uname -s)" == "MINGW64_NT"* || "$(uname -s)" == "MSYS_NT"* ]]; then
    echo "Running on Git Bash (Windows)"
	source set_user_bash_win.sh
	compose_file="compose-win.yml"
else
    echo "Unknown environment"
	exit 1
fi


cat << EOF > personal.env
rt_image=zeevb053/fedora-dev:14.07
app_ip=$app_ip
EOF



docker compose -f $compose_file --env-file personal.env up
