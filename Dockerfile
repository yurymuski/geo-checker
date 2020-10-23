FROM aandrewww/alpine-openresty-extended

WORKDIR /usr/local/openresty

# install supervisor
RUN apk update && apk add --no-cache supervisor

# install lua modules
RUN luarocks install lua-resty-http

# create app directory in container
RUN mkdir /usr/local/openresty/logs

# copy files from current dir to folder in container
COPY ./conf/nginx.conf /etc/nginx/conf.d
COPY ./conf/geoip.conf /etc/geoip.conf

COPY ./conf/crontab.txt /crontab.txt
# COPY ./conf/docker-entry.sh /docker-entry.sh
COPY ./conf/supervisord.conf /etc/

# Remove default nginx conf
RUN rm -f /etc/nginx/conf.d/default.conf

# set up crontab
RUN /usr/bin/crontab /crontab.txt

# log folders
RUN mkdir -p /var/log/cron
RUN mkdir -p /var/log/nginx

EXPOSE 80

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["bash", "/docker-entrypoint.sh"]
CMD ["start"]