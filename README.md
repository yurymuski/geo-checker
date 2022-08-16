# geo-checker
[![](https://img.shields.io/docker/cloud/build/ymuski/geo-checker?style=flat-square)](https://hub.docker.com/r/ymuski/geo-checker)
[![](https://img.shields.io/docker/cloud/automated/ymuski/geo-checker?style=flat-square)](https://hub.docker.com/r/ymuski/geo-checker)
[![](https://img.shields.io/docker/pulls/ymuski/geo-checker?style=flat-square)](https://hub.docker.com/r/ymuski/geo-checker)

## openresty (nginx) with geoip2 module, geoipupdate+cron.

## Usage:

```shell

# Retrive GEOIP credentials from `maxmind.com` and set variables
export GEOIP_ACCOUNTID="AccountID"
export GEOIP_LICENSEKEY="LicenseKey"
export GEOIP_EDITIONID="GeoLite2-Country" # "GeoLite2-Country" or "GeoIP2-Country"

# start docker container
docker run -d -v /tmp/geoip/:/usr/share/geoip/ -e GEOIP_ACCOUNTID=$GEOIP_ACCOUNTID -e GEOIP_LICENSEKEY=$GEOIP_LICENSEKEY -e GEOIP_EDITIONID=$GEOIP_EDITIONID --name geo-checker -p 8080:80 ymuski/geo-checker:latest

# interactive mode
docker run --rm -it -v ${PWD}/tmp/geoip/:/usr/share/geoip/ -e GEOIP_ACCOUNTID=$GEOIP_ACCOUNTID -e GEOIP_LICENSEKEY=$GEOIP_LICENSEKEY -e GEOIP_EDITIONID=$GEOIP_EDITIONID --name geo-checker -p 8080:80 ymuski/geo-checker

# test with any public IP
# Header priority: 1. X-Header-Real-Ip (Highest) 2. X-Custom-Real-Ip 3. X-Real-Ip 4. CF-Connecting-IP
curl localhost:8080 -H "X-Header-Real-Ip: 1.1.1.1"
curl localhost:8080 -H "X-Custom-Real-Ip: 1.1.1.1"
curl localhost:8080 -H "X-Real-Ip: 1.1.1.1"
curl localhost:8080 -H "CF-Connecting-IP: 1.1.1.1"
curl localhost:8080/ip/1.1.1.1

```

### Responce:
```
# Body
{"IP":"1.1.1.1","iso2Code":"AU","name":"Australia"}

# Responce headers
X-Real-IP: 1.1.1.1
X-Geo-Country-Code: AU
X-Geo-Country-Name: Australia
```

---
## docker image:
```shell
docker build -t ymuski/geo-checker .
docker pull ymuski/geo-checker
```

---
## Notes:
- if you use `nginx` as reverse-proxy:
```shell
location / {
    proxy_set_header X-Real-IP  $remote_addr;
    proxy_pass http://127.0.0.1:8080;
}
```
- if you use `Cloudflare + nginx` as reverse-proxy:
```shell
location / {
    proxy_pass http://127.0.0.1:8080;
}
```
