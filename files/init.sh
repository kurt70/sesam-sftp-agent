#!/bin/bash -l

# Generate get-files script
cat << EOF > /scripts/get-files.sh
#!/bin/bash -l
cd /www
echo "[\$(printf '%(%Y-%m-%d %T)T\n' -1)] - running : sshpass -p $SFT_PWD sftp -oStrictHostKeyChecking=no -oHostKeyAlgorithms=+ssh-dss ${SFT_USER}@${SFT_SERVER}:${SFT_HOST_PATH}*.*"
sshpass -p $SFT_PWD sftp -oStrictHostKeyChecking=no -oHostKeyAlgorithms=+ssh-dss ${SFT_USER}@${SFT_SERVER}:${SFT_HOST_PATH}*.*
chmod +r *.*
EOF

# Generate crontab file & register it
cat << EOF > crontab.ct
#start crontab
SHELL=/bin/bash
$CRON_EXPRESSION /scripts/get-files.sh >> /www/sftp.log 2>&1
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

#run nginx
nginx
#make logfile
touch /www/sftp.log
#run initial get
/scripts/get-files.sh
#run cron as a frontprocess
cron -f
