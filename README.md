# Geo-Checker | Simple GeoIP Lookup Server - Docker & Kubernetes (k8s)

[![](https://img.shields.io/docker/pulls/ymuski/geo-checker?style=flat-square)](https://hub.docker.com/r/ymuski/geo-checker)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/geo-checker)](https://artifacthub.io/packages/search?repo=geo-checker)

**Geo-checker** is a **simple** and high-performance **GeoIP lookup server** ready for **Docker** and **Kubernetes (K8s)**. Built on **OpenResty (Nginx)** and **MaxMind GeoIP** databases, it provides country name, ISO code, and other geolocation data with a built-in cron job for automatic `geoipupdate`.

👉 If you found Geo-Checker useful, please consider giving it a star. ⭐

## Live Demo
- [ip/8.8.8.8](https://geo.yurets.pro/ip/8.8.8.8) 
- [ip/2a03:2880:f189:80:face:b00c:0:25de](https://geo.yurets.pro/ip/2a03:2880:f189:80:face:b00c:0:25de)


## Features

- **High Performance**: Built on Nginx/OpenResty for low latency.
- **Automatic Updates**: Built-in cron job updates MaxMind databases automatically.
- **JSON Output**: Returns geolocation data in JSON format.
- **Docker & Kubernetes Ready**: Easy to deploy with Docker or Helm.
- **Flexible Input**: Lookup by API endpoint path or request headers.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [API Documentation](#api-documentation)
- [Configuration](#configuration)
- [Docker Image](#docker-image)
- [Helm Chart](#helm-chart)
- [Reverse Proxy Configuration](#reverse-proxy-configuration)
- [References](#references)

## Prerequisites

You need a MaxMind account to get the license keys for the GeoIP database.

```shell
# Retrive GEOIP credentials from `maxmind.com` and set variables
export GEOIP_ACCOUNTID="AccountID"
export GEOIP_LICENSEKEY="LicenseKey"
export GEOIP_EDITIONID="GeoLite2-Country" # "GeoLite2-Country", "GeoIP2-Country" or "GeoIP2-City"
```

## Quick Start

### Docker

**Standard Run:**

```shell
# start docker container
docker run -d -v /tmp/geoip/:/usr/share/geoip/ -e GEOIP_ACCOUNTID=$GEOIP_ACCOUNTID -e GEOIP_LICENSEKEY=$GEOIP_LICENSEKEY -e GEOIP_EDITIONID=$GEOIP_EDITIONID --name geo-checker -p 8080:80 ymuski/geo-checker:latest
```

**Interactive Mode:**

```shell
# interactive mode
docker run --rm -it -v ${PWD}/tmp/geoip/:/usr/share/geoip/ -e GEOIP_ACCOUNTID=$GEOIP_ACCOUNTID -e GEOIP_LICENSEKEY=$GEOIP_LICENSEKEY -e GEOIP_EDITIONID=$GEOIP_EDITIONID --name geo-checker -p 8080:80 ymuski/geo-checker
```

**Custom Update Schedule:**

```shell
# OPTIONAL: set custom GEOIP_CRONTAB, default is '48 14 * * 3,6'
# NOTE: maxmind databases are updated twice weekly, every Tuesday and Friday.
export GEOIP_CRONTAB="48 14 * * 3"

# interactive mode with custom crontab
docker run --rm -it -v ${PWD}/tmp/geoip/:/usr/share/geoip/ -e GEOIP_ACCOUNTID=$GEOIP_ACCOUNTID -e GEOIP_LICENSEKEY=$GEOIP_LICENSEKEY -e GEOIP_EDITIONID=$GEOIP_EDITIONID -e GEOIP_CRONTAB="$GEOIP_CRONTAB" --name geo-checker -p 8080:80 ymuski/geo-checker
```

## API Documentation

### Lookup by IP Address

Test with any public IP:

```shell
curl localhost:8080/ip/8.8.8.8
curl localhost:8080/ip/city/8.8.8.8
curl localhost:8080/ip/2a03:2880:f189:80:face:b00c:0:25de
curl localhost:8080/ip/city/2a03:2880:f189:80:face:b00c:0:25de
```

### Lookup by Header (My IP)

It is possible to pass any IP address as a header to get the country name and iso_code.
**Header priority:**
1. `X-Header-Real-Ip`
2. `X-Custom-Real-Ip`
3. `X-Real-Ip`
4. `CF-Connecting-IP`

```shell
curl localhost:8080/myip -H "X-Header-Real-Ip: 8.8.8.8"
curl localhost:8080/myip -H "X-Custom-Real-Ip: 8.8.8.8"
curl localhost:8080/myip -H "X-Real-Ip: 8.8.8.8"
curl localhost:8080/myip -H "CF-Connecting-IP: 8.8.8.8"
```

### Response Examples

**JSON Body:**

```json
{"IP":"8.8.8.8","iso2Code":"US","name":"United States"}

{"ip":"2a03:2880:f189:80:face:b00c:0:25de","country_iso_code":"GB","country_name":"United Kingdom","city_name":"London","continent_name":"Europe","subdivision_iso_code":"ENG","subdivision_name":"England"}
```

## Helm Chart

### Usage

Go to helm [Readme](helm/README.md#Usage)

### Publish new version of helm-chart

```sh
# update helm/Chart.yaml
cd helm/packages
helm package ../
cd ../
helm repo index . --url https://yurymuski.github.io/geo-checker/helm/
cd ../
```

## Reverse Proxy Configuration

### Nginx

If you use `nginx` as a reverse-proxy:

```nginx
location / {
    proxy_set_header X-Real-IP  $remote_addr;
    proxy_pass http://127.0.0.1:8080;
}
```

### Cloudflare + Nginx

If you use `Cloudflare + nginx` as a reverse-proxy:

```nginx
location / {
    proxy_pass http://127.0.0.1:8080;
}
```

## References

- [leev/ngx_http_geoip2_module](https://github.com/leev/ngx_http_geoip2_module)
- [man mmdblookup](https://maxmind.github.io/libmaxminddb/mmdblookup.html)
- [mmdbinspect examples](https://github.com/maxmind/mmdbinspect?tab=readme-ov-file#examples)
- [maxmind DB accuracy](https://www.maxmind.com/en/geoip2-city-accuracy-comparison)
- [maxmind geoip demo](https://www.maxmind.com/en/geoip-web-services-demo)
