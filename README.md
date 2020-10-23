# geo-checker
[![](https://img.shields.io/docker/cloud/build/ymuski/geo-checker?style=flat-square)](https://hub.docker.com/r/ymuski/geo-checker)
[![](https://img.shields.io/docker/cloud/automated/ymuski/geo-checker?style=flat-square)](https://hub.docker.com/r/ymuski/geo-checker)
[![](https://img.shields.io/docker/pulls/ymuski/geo-checker?style=flat-square)](https://hub.docker.com/r/ymuski/geo-checker)

### docker image:
```shell
docker pull ymuski/geo-checker
```

### Setup:
Set GEOIP credentials at [conf/geoip.conf](conf/geoip.conf)
 - AccountID
 - LicenseKey
 - EditionIDs

 Set witch EditionIDs to use at [conf/nginx.conf](conf/nginx.conf) and at [docker-entrypoint.sh](docker-entrypoint.sh) default `(/usr/share/geoip/GeoIP2-Country.mmdb`)
  - /usr/share/geoip/GeoIP2-Country.mmdb
  - /usr/share/geoip/GeoLite2-City.mmdb
  - /usr/share/geoip/GeoLite2-Country.mmdb

---
### Test:
```shell
docker run --rm -d  -v /tmp/geoip/:/usr/share/geoip/ -v ${PWD}/conf/geoip.conf:/etc/geoip.conf --name geo-checker -p 8080:80 ymuski/geo-checker:latest

# test with some IP/HOST
curl localhost:8080 -H "X-Real-Ip: 1.1.1.1" -H "Host: test"
```
