## Usage
```shell
export CLOUDFLARE_API_TOKEN=""

cd terraform
terraform fmt
terraform init
terraform plan -out=geo.plan
terraform apply geo.plan

```