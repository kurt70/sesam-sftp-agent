#!/bin/bash -l
cd /scripts
# Generate crontab file
cat << EOF > crontab.ct               
#start crontab 
$CRON_EXPRESSION /scripts/get-files.sh
#end crontab
EOF
crontab crontab.ct
# Generate nginx config
cat << EOF > /etc/nginx/conf.d/default.conf
server {
    listen $PROXY_PORT;
    server_name localhost;
    root /www;
    location / {
        autoindex on;
        sendfile on;
        sendfile_max_chunk 1m;
    }
}
EOF
nginx
/scripts/get-files.sh
sleep infinity