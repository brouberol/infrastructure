provider "aws" {
  region = "us-east-2"
}

provider "aws" {
  alias  = "euwest"
  region = "eu-west-3"
}

resource "aws_s3_bucket" "balthazar-rouberol-blog" {
  bucket   = "balthazar-rouberol-blog"
  provider = "aws.euwest"
  acl      = "public-read"
  region   = "eu-west-3"
  force_destroy = false
  versioning {
      enabled = false
      mfa_delete = false
  }
}
