terraform {
  backend "s3" {}
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.1.0"
    }
  }
  required_version = ">= 0.13"
}

module "global_vars" {
  source = "../global_vars"
}

provider "scaleway" {
  region  = "fr-par"
  zone    = "fr-par-1"
  version = "~> 1.17"
}

resource "scaleway_account_ssh_key" "ssh_key" {
  name       = element(split("== ", element(module.global_vars.ssh_keys, count.index)), 1)
  public_key = element(module.global_vars.ssh_keys, count.index)
  count      = length(module.global_vars.ssh_keys)
}

resource "scaleway_instance_ip" "gallifrey_ip" {}

resource "scaleway_instance_volume" "gallifrey_snap" {
  name       = "snapshot_gallifrey_0_2019-06-30_17-29"
  size_in_gb = 25
  type       = "l_ssd"
}

resource "scaleway_instance_volume" "gallifrey_data" {
  name       = "Volume-1"
  size_in_gb = 15
  type       = "l_ssd"
}

resource "scaleway_instance_server" "gallifrey" {
  name                  = module.global_vars.gallifrey_scaleway_server_name
  image                 = module.global_vars.gallifrey_scaleway_image_id
  type                  = module.global_vars.gallifrey_scaleway_server_type
  ip_id                 = scaleway_instance_ip.gallifrey_ip.id
  enable_ipv6           = false
  tags                  = []
  additional_volume_ids = [scaleway_instance_volume.gallifrey_data.id]
  security_group_id     = scaleway_instance_security_group.default_sg.id

  depends_on = [
    scaleway_instance_ip.gallifrey_ip,
    scaleway_instance_volume.gallifrey_snap,
    scaleway_instance_volume.gallifrey_data,
    scaleway_instance_security_group.default_sg
  ]
}

resource "scaleway_instance_ip_reverse_dns" "gallifrey" {
  ip_id   = scaleway_instance_ip.gallifrey_ip.id
  reverse = module.global_vars.root_domain

  depends_on = [scaleway_instance_ip.gallifrey_ip]
}

resource "scaleway_instance_security_group" "default_sg" {
  description = "Auto generated security group."
  stateful    = false
}

resource "scaleway_object_bucket" "brouberol-nextcloud" {
  name = "brouberol-nextcloud"
  acl  = "private"
}
