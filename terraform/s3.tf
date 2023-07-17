module "data" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.14.0"

  bucket                  = "${local.environment}.data"
  acl                     = "private"
  
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = var.tags
}

module "sharing" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.3.0"

  bucket                  = "${local.environment}.sharing"
  acl                     = "private"
  
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = var.tags
}
