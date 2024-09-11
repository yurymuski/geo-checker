# geo-checker
[![](https://img.shields.io/docker/pulls/ymuski/geo-checker?style=flat-square)](https://hub.docker.com/r/ymuski/geo-checker)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/geo-checker)](https://artifacthub.io/packages/search?repo=geo-checker)

Geo-checker is the IP address resolver to the country_name and iso_code.
Based on openresty (nginx) and maxmind geo DB (build-in cron for geoipupdate).


## Usage:

```shell

# Retrive GEOIP credentials from `maxmind.com` and set variables
export GEOIP_ACCOUNTID="AccountID"
export GEOIP_LICENSEKEY="LicenseKey"
export GEOIP_EDITIONID="GeoLite2-Country" # "GeoLite2-Country", "GeoIP2-Country" or "GeoIP2-City"

# OPTIONAL: set custom GEOIP_CRONTAB, default is '48 14 * * 3,6'
# NOTE: maxmind databases are updated twice weekly, every Tuesday and Friday.
export GEOIP_CRONTAB="48 14 * * 3"

# start docker container
docker run -d -v /tmp/geoip/:/usr/share/geoip/ -e GEOIP_ACCOUNTID=$GEOIP_ACCOUNTID -e GEOIP_LICENSEKEY=$GEOIP_LICENSEKEY -e GEOIP_EDITIONID=$GEOIP_EDITIONID --name geo-checker -p 8080:80 ymuski/geo-checker:latest

# interactive mode
docker run --rm -it -v ${PWD}/tmp/geoip/:/usr/share/geoip/ -e GEOIP_ACCOUNTID=$GEOIP_ACCOUNTID -e GEOIP_LICENSEKEY=$GEOIP_LICENSEKEY -e GEOIP_EDITIONID=$GEOIP_EDITIONID --name geo-checker -p 8080:80 ymuski/geo-checker

# interactive mode with custom crontab
docker run --rm -it -v ${PWD}/tmp/geoip/:/usr/share/geoip/ -e GEOIP_ACCOUNTID=$GEOIP_ACCOUNTID -e GEOIP_LICENSEKEY=$GEOIP_LICENSEKEY -e GEOIP_EDITIONID=$GEOIP_EDITIONID -e GEOIP_CRONTAB="$GEOIP_CRONTAB" --name geo-checker -p 8080:80 ymuski/geo-checker

# test with any public IP
# Header priority: 1. X-Header-Real-Ip (Highest) 1. X-Custom-Real-Ip 2. X-Real-Ip 3. CF-Connecting-IP
curl localhost:8080 -H "X-Header-Real-Ip: 8.8.8.8"
curl localhost:8080 -H "X-Custom-Real-Ip: 8.8.8.8"
curl localhost:8080 -H "X-Real-Ip: 8.8.8.8"
curl localhost:8080 -H "CF-Connecting-IP: 8.8.8.8"
curl localhost:8080/ip/8.8.8.8
curl localhost:8080/ip/city/8.8.8.8
curl localhost:8080/ip/2a03:2880:f189:80:face:b00c:0:25de
curl localhost:8080/ip/city/2a03:2880:f189:80:face:b00c:0:25de

```

### Response:
```
# Body
{"IP":"8.8.8.8","iso2Code":"US","name":"United States"}

{"ip":"2a03:2880:f189:80:face:b00c:0:25de","country_iso_code":"GB","country_name":"United Kingdom","city_name":"London","continent_name":"Europe","subdivision_iso_code":"ENG","subdivision_name":"England"}

# Response headers
< X-Real-IP: 8.8.8.8
< X-Geo-Country-Code: US
< X-Geo-Country-Name: United States

```

---
## docker image:
```shell
docker build -t ymuski/geo-checker .
docker push ymuski/geo-checker
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

---
## helm chart

### Usage:
Go to helm [Readme](helm/README.md#Usage)

### Publish new version of helm-chart:
```sh
cd helm/packages
helm package ../
cd ../
helm repo index . --url https://yurymuski.github.io/geo-checker/helm/
```

---
## refs:
- [leev/ngx_http_geoip2_module](https://github.com/leev/ngx_http_geoip2_module)
- [man mmdblookup](https://maxmind.github.io/libmaxminddb/mmdblookup.html)
- [mmdbinspect examples](https://github.com/maxmind/mmdbinspect?tab=readme-ov-file#examples)
- [maxmind DB accuracy](https://www.maxmind.com/en/geoip2-city-accuracy-comparison)
- [maxmind geoip demo](https://www.maxmind.com/en/geoip-web-services-demo)
