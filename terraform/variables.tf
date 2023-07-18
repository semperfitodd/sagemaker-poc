data "aws_availability_zones" "main" {}

locals {
  availability_zones = [
    data.aws_availability_zones.main.names[0],
    data.aws_availability_zones.main.names[1]
  ]

  public_subnets = [
    cidrsubnet(local.vpc_cidr, 6, 0),
    cidrsubnet(local.vpc_cidr, 6, 1)
  ]

  private_subnets = [
    cidrsubnet(local.vpc_cidr, 6, 2),
    cidrsubnet(local.vpc_cidr, 6, 3)
  ]

  database_subnets = [
    cidrsubnet(local.vpc_cidr, 6, 4),
    cidrsubnet(local.vpc_cidr, 6, 5)
  ]

  project_name = "mlops-sagemaker"

  region = "us-east-1"

  vpc_cidr = "10.0.0.0/16"

  vpc_route_tables = flatten([module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])
}

variable "tags" {
  type    = map(string)
  default = {
    team: "mlops",
    usage: "sagemaker",
    lob: "sboxawsai2",
    appid: "APP-xxxx"
  }
}
