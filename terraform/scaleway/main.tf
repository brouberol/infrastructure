module "global_vars" {
  source = "../global_vars"
}

provider "scaleway" {
  region = "par1"
}

resource "scaleway_ssh_key" "ssh_key" {
    key = "${module.global_vars.ssh_key}"
}

resource "scaleway_server" "gallifrey" {
  name  = "gallifrey"
  image = "c564be4f-2dac-4b1b-a239-3f3a441700ed"
  type  = "START1-XS"
  enable_ipv6 = false
  tags = []
}
