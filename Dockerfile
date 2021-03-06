FROM aandrewww/alpine-openresty-extended

WORKDIR /usr/local/openresty

# install supervisor
RUN apk update && apk add --no-cache supervisor

# copy files from current dir to folder in container
COPY ./conf/nginx.conf /etc/nginx/conf.d/
COPY ./favicon.ico /usr/local/openresty/nginx/html/
COPY ./conf/geoip.conf /etc/geoip.conf
COPY ./conf/crontab.txt /crontab.txt
COPY ./conf/supervisord.conf /etc/

# Remove default nginx conf
RUN rm -f /etc/nginx/conf.d/default.conf

# set up crontab
RUN /usr/bin/crontab /crontab.txt
RUN mkdir -p /var/log/cron

EXPOSE 80

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["bash", "/docker-entrypoint.sh"]
CMD ["start"]