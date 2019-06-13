terraform {
  backend "s3" {}
}

provider "aws" {
  region = "us-east-2"
}

provider "aws" {
  alias  = "euwest"
  region = "eu-west-3"
}

module "global_vars" {
  source = "../global_vars"
}

resource "aws_s3_bucket" "balthazar-rouberol-blog" {
  bucket   = "${module.global_vars.blog_s3_bucket_name}"
  provider = "aws.euwest"
  acl      = "public-read"
  region   = "${module.global_vars.blog_s3_bucket_region}"
  force_destroy = false
  versioning {
      enabled = false
      mfa_delete = false
  }
}

resource "aws_s3_bucket" "tfstate" {
  bucket   = "${module.global_vars.tfstate_s3_bucket_name}"
  provider = "aws.euwest"
  acl      = "private"
  region   = "${module.global_vars.blog_s3_bucket_region}"
  force_destroy = true
  versioning {
      enabled = false
      mfa_delete = false
  }
}
