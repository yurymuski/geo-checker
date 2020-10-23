# geo-checker
[![](https://img.shields.io/docker/cloud/build/ymuski/geo-checker?style=flat-square)](https://hub.docker.com/r/ymuski/geo-checker)
[![](https://img.shields.io/docker/cloud/automated/ymuski/geo-checker?style=flat-square)](https://hub.docker.com/r/ymuski/geo-checker)
[![](https://img.shields.io/docker/pulls/ymuski/geo-checker?style=flat-square)](https://hub.docker.com/r/ymuski/geo-checker)

### docker image:
```shell
docker pull ymuski/geo-checker
```

### Setup:
Retrive GEOIP credentials from `maxmind.com`

Set variables:

 - GEOIP_ACCOUNTID=`AccountID`
 - GEOIP_LICENSEKEY=`LicenseKey`
 - GEOIP_EDITIONID="GeoLite2-Country" or "GeoIP2-Country"

---
### Test:
```shell
docker run --rm -d  -v /tmp/geoip/:/usr/share/geoip/ -e GEOIP_ACCOUNTID="AccountID" -e GEOIP_LICENSEKEY="LicenseKey" -e GEOIP_EDITIONID="GeoLite2-Country" --name geo-checker -p 8080:80 ymuski/geo-checker:latest

# test with some IP/HOST
curl localhost:8080 -H "X-Real-Ip: 1.1.1.1" -H "Host: test"
```
