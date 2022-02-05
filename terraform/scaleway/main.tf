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

resource "scaleway_instance_security_group" "default_sg" {
  description = "Auto generated security group."
  stateful    = false
}
