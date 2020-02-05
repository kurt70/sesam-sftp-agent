#!/bin/bash -l
cd /www
sshpass -p $SFT_PWD sftp -oStrictHostKeyChecking=no -oHostKeyAlgorithms=+ssh-dss ${SFT_USER}@${SFT_SERVER}:${SFT_HOST_PATH}*.*
chmod +r *.*