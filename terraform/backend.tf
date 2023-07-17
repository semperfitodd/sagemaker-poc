terraform {
  backend "s3" {
    bucket = "sbox-mlops-tf-state"
    region = "us-east-1"
  }
}