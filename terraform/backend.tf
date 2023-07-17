terraform {
  backend "s3" {
    bucket = "sboxaws-mlops-tf-state"
    region = "us-east-1"
  }
}
