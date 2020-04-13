FROM nginx

ENV CRON_EXPRESSION='*/5 * * * *'
ENV SFT_SERVER='sftp.test.no'
ENV SFT_USER="User"
ENV SFT_PWD="Password"
ENV SFT_HOST_PATH="/"
ENV PROXY_PORT="5000"

WORKDIR /scripts
COPY files/*.sh /scripts/
RUN apt-get update && apt-get install sshpass -y && apt-get install cron -y && chmod u+x /scripts/*.sh
WORKDIR /www
RUN chmod +r /www
CMD [ "bash", "/scripts/init.sh" ]