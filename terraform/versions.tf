provider "aws" {
  region = local.region

  default_tags {
    tags = {
      Owner       = "Prasad P"
      Project     = "SageMaker POC"
      Provisioner = "Terraform"
    }
  }
}

terraform {
  required_version = ">= 1.2.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
