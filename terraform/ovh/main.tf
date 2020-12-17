terraform {
  required_version = ">= 0.12.0"
  backend "s3" {}
}

provider "ovh" {
  endpoint = "ovh-eu"
}

module "global_vars" {
  source = "../global_vars"
}

resource "ovh_domain_zone_record" "root_domain" {
    zone = "${module.global_vars.root_domain}"
    fieldtype = "A"
    ttl = "0"
    target = "${module.global_vars.main_domain_ip}"
}

resource "ovh_domain_zone_record" "subdomains" {
    zone = "${module.global_vars.root_domain}"
    subdomain = "${element(module.global_vars.subdomains, count.index)}"
    fieldtype = "CNAME"
    ttl = "0"
    target = "${module.global_vars.root_domain}."

    count = "${length(module.global_vars.subdomains)}"
    depends_on = [ovh_domain_zone_record.root_domain]
}

resource "ovh_domain_zone_record" "rpi" {
    zone = "${module.global_vars.root_domain}"
    subdomain = "${module.global_vars.root_private_subdomain}"
    fieldtype = "A"
    ttl = "0"
    target = "${module.global_vars.rpi_local_ip}"
}

resource "ovh_domain_zone_record" "private_subdomains" {
    zone = "${module.global_vars.root_domain}"
    subdomain = "${element(module.global_vars.private_subdomains, count.index)}"
    fieldtype = "CNAME"
    ttl = "0"
    target = "${module.global_vars.root_private_subdomain}.${module.global_vars.root_domain}."

    count = "${length(module.global_vars.private_subdomains)}"
    depends_on = [ovh_domain_zone_record.rpi]
}

resource "ovh_domain_zone_record" "home" {
    zone = "${module.global_vars.root_domain}"
    subdomain = "${module.global_vars.home_subdomain}"
    fieldtype = "CNAME"
    ttl = "0"
    target = "${module.global_vars.home_dyn_dns_domain}."

    depends_on = [ovh_domain_zone_record.root_domain]
}

resource "ovh_domain_zone_record" "sophro_domain" {
    zone = "${module.global_vars.sophro_domain}"
    fieldtype = "A"
    ttl = "0"
    target = "${module.global_vars.sophro_domain_ip}"
}

resource "ovh_domain_zone_record" "home_subdomains" {
    zone = "${module.global_vars.root_domain}"
    subdomain = "${element(module.global_vars.home_subdomains, count.index)}"
    fieldtype = "CNAME"
    ttl = "0"
    target = "${module.global_vars.home_subdomain}.${module.global_vars.root_domain}."

    count = "${length(module.global_vars.home_subdomains)}"
    depends_on = [ovh_domain_zone_record.home]
}


resource "ovh_domain_zone_record" "grand_cedre_subdomain" {
    zone = "${module.global_vars.sophro_domain}"
    subdomain = "grand-cedre"
    fieldtype = "CNAME"
    ttl = "0"
    target = "${module.global_vars.root_domain}."

    depends_on = [ovh_domain_zone_record.root_domain]

}

resource "ovh_domain_zone_record" "recyclette_domain" {
    zone = "${module.global_vars.recyclette_domain}"
    fieldtype = "A"
    ttl = "0"
    target = "${module.global_vars.shopify_ip}"
}


resource "ovh_domain_zone_record" "recyclette_domain_cname" {
    zone = "${module.global_vars.recyclette_domain}"
    subdomain = "www"
    fieldtype = "CNAME"
    ttl = "0"
    target = "${module.global_vars.shopify_domain}."

    depends_on = [ovh_domain_zone_record.recyclette_domain]
}
