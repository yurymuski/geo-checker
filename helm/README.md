# Geo-Checker Helm Chart

[![](https://img.shields.io/docker/pulls/ymuski/geo-checker?style=flat-square)](https://hub.docker.com/r/ymuski/geo-checker)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/geo-checker)](https://artifacthub.io/packages/search?repo=geo-checker)

**Geo-checker** is a **simple** and high-performance **GeoIP lookup server** ready for **Docker** and **Kubernetes (K8s)**. Built on **OpenResty (Nginx)** and **MaxMind GeoIP** databases, it provides country name, ISO code, and other geolocation data with a built-in cron job for automatic `geoipupdate`.

## Features

- **High Performance**: Built on Nginx/OpenResty for low latency.
- **Automatic Updates**: Built-in cron job updates MaxMind databases automatically.
- **JSON Output**: Returns geolocation data in JSON format.
- **Flexible Input**: Lookup by API endpoint path or request headers.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.0+
- **MaxMind Account**: You need a MaxMind account to get the license keys for the GeoIP database.

## Installing the Chart

To install the chart with the release name `my-geo-checker`:

```console
$ helm repo add geo-checker https://yurymuski.github.io/geo-checker/helm/
$ helm repo update
$ helm install my-geo-checker geo-checker/geo-checker \
  --set maxmind.geoipAccountid="YourAccountID" \
  --set maxmind.geoipLicensekey="YourLicenseKey"
```

> **Note**: You must replace `YourAccountID` and `YourLicenseKey` with your actual MaxMind credentials.

## Uninstalling the Chart

To uninstall/delete the `my-geo-checker` deployment:

```console
$ helm uninstall my-geo-checker
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Geo-Checker chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Image repository | `ymuski/geo-checker` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `image.tag` | Image tag (overrides chart appVersion) | `""` |
| `serviceAccount.create` | Specifies whether a service account should be created | `true` |
| `serviceAccount.name` | The name of the service account to use | `""` |
| `service.type` | Kubernetes Service type | `ClusterIP` |
| `service.port` | Kubernetes Service port | `80` |
| `ingress.enabled` | Enable Ingress | `false` |
| `ingress.hosts` | Ingress hosts | `[{host: chart-example.local, paths: [{path: /, pathType: ImplementationSpecific}]}]` |
| `resources` | CPU/Memory resource requests/limits | `{}` |
| `autoscaling.enabled` | Enable Horizontal Pod Autoscaler | `false` |
| `maxmind.geoipAccountid` | MaxMind Account ID (Required) | `"AccountID"` |
| `maxmind.geoipLicensekey` | MaxMind License Key (Required) | `"LicenseKey"` |
| `maxmind.geoipEditionid` | MaxMind Edition ID | `"GeoLite2-Country"` |
| `env.GEOIP_CRONTAB` | Crontab schedule for database updates | `'48 14 * * 3,6'` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```console
$ helm install my-geo-checker geo-checker/geo-checker \
  --set replicaCount=2 \
  --set maxmind.geoipAccountid="123456" \
  --set maxmind.geoipLicensekey="abcdef123456"
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example:

```console
$ helm install my-geo-checker geo-checker/geo-checker -f values.yaml
```

## Usage

Once installed, you can access the service within the cluster or via Ingress/LoadBalancer.

### Lookup by IP Address

```shell
curl http://<service-ip>/ip/8.8.8.8
```

### Lookup by Header (My IP)

```shell
curl http://<service-ip>/myip -H "X-Real-Ip: 8.8.8.8"
```