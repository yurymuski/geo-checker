data "cloudflare_zone" "main" {
  name = var.domain_zone
}

resource "cloudflare_worker_script" "geo-cf" {
  name    = "geo-cf"
  content = file("../geo-cf.js")
}

resource "cloudflare_worker_route" "geo-cf" {
  zone_id     = data.cloudflare_zone.main.id
  pattern     = "${var.domain}/cf/*"
  script_name = cloudflare_worker_script.geo-cf.name
}
