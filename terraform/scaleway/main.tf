terraform {
  required_version = ">= 0.12.0"
  backend "s3" {}
}

module "global_vars" {
  source = "../global_vars"
}

provider "scaleway" {
  region = "${module.global_vars.scaleway_region}"
}

resource "scaleway_ssh_key" "ssh_key" {
    key = "${element(module.global_vars.ssh_keys, count.index)}"
    count = "${length(module.global_vars.ssh_keys)}"
}

resource "scaleway_server" "gallifrey" {
  name  = "${module.global_vars.gallifrey_scaleway_server_name}"
  image = "${module.global_vars.gallifrey_scaleway_image_id}"
  type  = "${module.global_vars.gallifrey_scaleway_server_type}"
  enable_ipv6 = false
  tags = []
}

resource "scaleway_ip" "gallifrey_ip" {
  server = "${scaleway_server.gallifrey.id}"
}

resource "scaleway_ip_reverse_dns" "gallifrey" {
  ip = "${scaleway_ip.gallifrey_ip.id}"
  reverse = "${module.global_vars.root_domain}"
}

resource "scaleway_volume" "gallifrey_snap" {
  name       = "snapshot_gallifrey_0_2019-06-30_17-29"
  size_in_gb = 25
  type       = "l_ssd"
}

resource "scaleway_volume" "gallifrey_data" {
  name       = "Volume-1"
  size_in_gb = 15
  type       = "l_ssd"
}

resource "scaleway_security_group" "default_sg" {
  name = "Default security group"
  description             = "Auto generated security group."
  enable_default_security = false
  stateful = false
}
