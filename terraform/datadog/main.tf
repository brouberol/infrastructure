terraform {
  backend "s3" {}
  required_providers {
    datadog = {
      source  = "datadog/datadog"
      version = "~> 3.10.0"
    }
  }
  required_version = ">= 0.13"
}

provider "datadog" {}

module "global_vars" {
  source = "../global_vars"
}
