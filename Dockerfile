FROM ymuski/alpine-openresty-geoip

# install supervisor
RUN apk update && apk add --no-cache supervisor

# copy files from current dir to folder in container
COPY ./conf/nginx.conf /etc/nginx/conf.d/
COPY ./favicon.ico /usr/local/openresty/nginx/html/
COPY ./conf/geoip.conf /opt/geoip.conf
COPY ./conf/crontab.txt /opt/crontab.txt
COPY ./conf/supervisord.conf /opt/

# Remove default nginx conf
RUN rm -f /etc/nginx/conf.d/default.conf

# set up crontab
RUN /usr/bin/crontab /opt/crontab.txt
RUN mkdir -p /var/log/cron

EXPOSE 80

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["bash", "/docker-entrypoint.sh"]
CMD ["start"]