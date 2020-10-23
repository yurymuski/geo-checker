#!/bin/sh
set -eu

# GEOIP_ACCOUNTID, GEOIP_LICENSEKEY,GEOIP_EDITIONID should be set otherwise unbound variable error (due to set -u)
sed -i s/GEOIP_ACCOUNTID/$GEOIP_ACCOUNTID/g /etc/geoip.conf;
sed -i s/GEOIP_LICENSEKEY/$GEOIP_LICENSEKEY/g /etc/geoip.conf;
sed -i s/GEOIP_EDITIONID/$GEOIP_EDITIONID/g /etc/geoip.conf;
sed -i s/GEOIP_EDITIONID/$GEOIP_EDITIONID/g /etc/nginx/conf.d/nginx.conf;

case $1 in

  start)

    if [ ! -f /usr/share/geoip/$GEOIP_EDITIONID.mmdb ]; then
      echo "/usr/share/geoip/$GEOIP_EDITIONID.mmdb is not present; downloading"
      /usr/local/bin/geoipupdate -v -f /etc/geoip.conf -d /usr/share/geoip
    fi
    exec /usr/bin/supervisord -c /etc/supervisord.conf
  ;;

  *)
    exec "$@"
  ;;

esac

exit 0
