provider "aws" {
  region = local.region

  default_tags {
    tags = {
      Owner       = "Todd"
      Project     = "SageMaker POC"
      Provisioner = "Terraform"
    }
  }
}

terraform {
  required_version = "~> 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}