terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.46.0"
    }
  }
  required_version = ">= 0.13"
}

provider "aws" {
  alias  = "euwest"
  region = module.global_vars.blog_s3_bucket_region
}

module "global_vars" {
  source = "../global_vars"
}

resource "aws_s3_bucket" "balthazar-rouberol-blog" {
  bucket   = module.global_vars.blog_s3_bucket_name
  provider = aws.euwest
  acl      = "public-read"
  force_destroy = false
  versioning {
      enabled = false
      mfa_delete = false
  }
}

resource "aws_s3_bucket" "tfstate" {
  bucket   = module.global_vars.tfstate_s3_bucket_name
  provider = aws.euwest
  acl      = "private"
  force_destroy = true
  versioning {
      enabled = false
      mfa_delete = false
  }
}
