#!/bin/sh

set -e

case $1 in

  start)

    if [ ! -f /usr/share/geoip/GeoIP2-Country.mmdb ]; then
      echo "/usr/share/geoip/GeoIP2-Country.mmdb is not present; downloading"
      /usr/local/bin/geoipupdate -v -f /etc/geoip.conf -d /usr/share/geoip
    fi
    exec /usr/bin/supervisord -c /etc/supervisord.conf
  ;;

  *)
    exec "$@"
  ;;

esac

exit 0
