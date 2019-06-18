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
