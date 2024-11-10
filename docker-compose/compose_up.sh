#!/bin/bash -x

# run docker compose with update of enviroments

app_ip=$(hostname -i | sed -rn 's/.*(128[[:digit:]]*\.[[:digit:]]*\.[[:digit:]]*\.[[:digit:]]*).*/\1/p')

source set_user_bash.sh
cat << EOF > personal.env
rt_image=zeevb053/fedora-dev:14.06
app_ip=$app_ip
EOF

source set_user_bash.sh
docker compose --env-file personal.env up
