terraform {
  backend "s3" {
    bucket = "${local.project_name}-tf-state"
    region = "us-east-1"
  }
}
