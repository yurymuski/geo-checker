# geo-checker

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
docker run --rm -d  -v /tmp/geoip/:/usr/share/geoip/ --name geo-checker -p 8080:80 geo-checker:latest

# test with some IP/HOST
curl localhost:8080 -H "X-Real-Ip: 1.1.1.1" -H "Host: test"
```