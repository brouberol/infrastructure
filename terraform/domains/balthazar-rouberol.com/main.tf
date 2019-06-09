provider "ovh" {
  endpoint = "ovh-eu"
}

resource "ovh_domain_zone_record" "root_domain" {
    zone = "balthazar-rouberol.com"
    fieldtype = "A"
    ttl = "0"
    target = "${var.main_domain_ip}"
}

resource "ovh_domain_zone_record" "subdomains" {
    zone = "balthazar-rouberol.com"
    subdomain = "${element(var.subdomains, count.index)}"
    fieldtype = "CNAME"
    ttl = "0"
    target = "balthazar-rouberol.com."

    count = "${length(var.subdomains)}"
}