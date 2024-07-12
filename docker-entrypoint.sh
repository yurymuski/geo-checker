#!/bin/sh
set -eu

# GEOIP_ACCOUNTID, GEOIP_LICENSEKEY,GEOIP_EDITIONID should be set otherwise unbound variable error (due to set -u)
sed -i s/GEOIP_ACCOUNTID/$GEOIP_ACCOUNTID/g /opt/geoip.conf;
sed -i s/GEOIP_LICENSEKEY/$GEOIP_LICENSEKEY/g /opt/geoip.conf;
sed -i s/GEOIP_EDITIONID/$GEOIP_EDITIONID/g /opt/geoip.conf;
sed -i s/GEOIP_EDITIONID/$GEOIP_EDITIONID/g /etc/nginx/conf.d/nginx.conf;

# Update geoipupdate cron
GEOIP_CRONTAB="${GEOIP_CRONTAB:-48 14 * * 3,6}" # NOTE: maxmind databases are updated twice weekly, every Tuesday and Friday.
sed -i s/GEOIP_CRONTAB/"$GEOIP_CRONTAB"/g /opt/crontab.txt;
/usr/bin/crontab /opt/crontab.txt

mkdir -p /usr/share/geoip

case $1 in

  start)

    if [ ! -f /usr/share/geoip/$GEOIP_EDITIONID.mmdb ]; then
      echo "/usr/share/geoip/$GEOIP_EDITIONID.mmdb is not present; downloading"
      /usr/local/bin/geoipupdate -v -f /opt/geoip.conf -d /usr/share/geoip
    fi
    exec /usr/bin/supervisord -c /opt/supervisord.conf
  ;;

  *)
    exec "$@"
  ;;

esac

exit 0
