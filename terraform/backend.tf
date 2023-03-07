terraform {
  backend "s3" {
    bucket = "bsc.sandbox.terraform.state"
    key    = "sagemaker"
    region = "us-east-2"
  }
}