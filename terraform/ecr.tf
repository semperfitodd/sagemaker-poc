resource "aws_ecr_repository" "this" {
  name                 = local.project_name
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }
}
