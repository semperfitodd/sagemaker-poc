data "aws_iam_policy" "AmazonSageMakerCanvasFullAccess" {
  name = "AmazonSageMakerCanvasFullAccess"
}

data "aws_iam_policy" "AmazonSageMakerFullAccess" {
  name = "AmazonSageMakerFullAccess"
}

data "aws_iam_policy" "AmazonSageMakerCanvasForecastAccess" {
  name = "AmazonSageMakerCanvasForecastAccess"
}

data "aws_iam_policy_document" "sagemaker_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "sagemaker_forecast_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["forecast.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "sagemaker_s3_data" {
  statement {
    actions   = ["s3:ListBucket"]
    effect    = "Allow"
    resources = [module.data.s3_bucket_arn]
  }
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    effect    = "Allow"
    resources = ["${module.data.s3_bucket_arn}/*"]
  }
}

resource "aws_iam_policy" "sagemaker_s3_data" {
  name   = "sagemaker_s3_data"
  policy = data.aws_iam_policy_document.sagemaker_s3_data.json
}

resource "aws_iam_role" "sagemaker_domain" {
  name               = "${local.project_name}-sagemaker-executionrole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.sagemaker_assume_role.json

  tags = var.tags
}

resource "aws_iam_role" "sagemaker_forecast" {
  name               = "${local.project_name}-sagemaker-forecastrole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.sagemaker_assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "AmazonSageMakerCanvasFullAccess" {
  policy_arn = data.aws_iam_policy.AmazonSageMakerCanvasFullAccess.arn
  role       = aws_iam_role.sagemaker_domain.id
}

resource "aws_iam_role_policy_attachment" "AmazonSageMakerCanvasForecastAccess" {
  policy_arn = data.aws_iam_policy.AmazonSageMakerCanvasForecastAccess.arn
  role       = aws_iam_role.sagemaker_domain.id
}

resource "aws_iam_role_policy_attachment" "AmazonSageMakerFullAccess" {
  policy_arn = data.aws_iam_policy.AmazonSageMakerFullAccess.arn
  role       = aws_iam_role.sagemaker_domain.id
}

resource "aws_iam_role_policy_attachment" "sagemaker_s3_data" {
  policy_arn = aws_iam_policy.sagemaker_s3_data.arn
  role       = aws_iam_role.sagemaker_domain.id
}

resource "aws_sagemaker_domain" "this" {
  domain_name = "${local.project_name}-domain"
  auth_mode   = "IAM"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnets


  default_space_settings {
    execution_role = aws_iam_role.sagemaker_domain.arn
  }

  default_user_settings {
    execution_role = aws_iam_role.sagemaker_domain.arn

    canvas_app_settings {
      time_series_forecasting_settings {
        amazon_forecast_role_arn = aws_iam_role.sagemaker_forecast.arn
        status                   = "ENABLED"
      }
    }

    jupyter_server_app_settings {
      lifecycle_config_arns = []

      default_resource_spec {
        instance_type       = "system"
      }
    }

    sharing_settings {
      notebook_output_option = "Allowed"
      s3_output_path         = "s3://${module.sharing.s3_bucket_id}/sharing"
    }
  }
}

resource "aws_sagemaker_user_profile" "this" {
  domain_id         = aws_sagemaker_domain.this.id
  user_profile_name = "${local.project_name}-profile"


  user_settings {
    execution_role  = aws_iam_role.sagemaker_domain.arn
    security_groups = []

    canvas_app_settings {
      time_series_forecasting_settings {
        amazon_forecast_role_arn = aws_iam_role.sagemaker_forecast.arn
        status                   = "ENABLED"
      }
    }

    jupyter_server_app_settings {
      lifecycle_config_arns = []

      default_resource_spec {
        instance_type       = "system"
      }
    }
  }

  tags = var.tags
}
