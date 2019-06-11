provider "ovh" {
  endpoint = "ovh-eu"
}

resource "ovh_domain_zone_record" "root_domain" {
    zone = "${var.root_domain}"
    fieldtype = "A"
    ttl = "0"
    target = "${var.main_domain_ip}"
}

resource "ovh_domain_zone_record" "subdomains" {
    zone = "${var.root_domain}"
    subdomain = "${element(var.subdomains, count.index)}"
    fieldtype = "CNAME"
    ttl = "0"
    target = "${var.root_domain}."

    count = "${length(var.subdomains)}"
    depends_on = [ovh_domain_zone_record.root_domain]
}

resource "ovh_domain_zone_record" "rpi" {
    zone = "${var.root_domain}"
    subdomain = "${var.root_private_subdomain}"
    fieldtype = "A"
    ttl = "0"
    target = "${var.rpi_local_ip}"
}

resource "ovh_domain_zone_record" "private_subdomains" {
    zone = "${var.root_domain}"
    subdomain = "${element(var.private_subdomains, count.index)}"
    fieldtype = "CNAME"
    ttl = "0"
    target = "${var.root_private_subdomain}.${var.root_domain}."

    count = "${length(var.private_subdomains)}"
    depends_on = [ovh_domain_zone_record.rpi]
}