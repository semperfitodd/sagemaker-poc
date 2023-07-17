resource "aws_ecr_lifecycle_policy" "this" {
  policy = jsonencode(
    {
      rules = [
        {
          action = {
            type = "expire"
          }
          description  = "test"
          rulePriority = 1
          selection = {
            countNumber = 1
            countType   = "imageCountMoreThan"
            tagStatus   = "untagged"
          }
        },
      ]
    }
  )

  repository = aws_ecr_repository.this.name
}

resource "aws_ecr_repository" "this" {
  name                 = local.environment
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }
}