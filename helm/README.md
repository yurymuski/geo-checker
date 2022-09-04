Geo-checker is the IP address resolver to the country_name and iso_code.
Based on openresty (nginx) and maxmind geo DB (build-in cron for geoipupdate).


### Usage:
```sh
helm repo add geo-checker https://yurymuski.github.io/geo-checker/helm/
helm repo update

# Retrive GEOIP credentials from `maxmind.com` and install with setting variables
helm upgrade --install my-geo-checker geo-checker/geo-checker --set maxmind.geoipAccountid="AccountID" --set maxmind.geoipLicensekey="LicenseKey"

# Uninstall
helm uninstall my-geo-checker
```