data "aws_availability_zones" "main" {}

locals {
  availability_zones = [
    data.aws_availability_zones.main.names[0],
    data.aws_availability_zones.main.names[1],
    data.aws_availability_zones.main.names[2],
  ]

  public_subnets = [
    cidrsubnet(local.vpc_cidr, 6, 0),
    cidrsubnet(local.vpc_cidr, 6, 1),
    cidrsubnet(local.vpc_cidr, 6, 2),
  ]

  private_subnets = [
    cidrsubnet(local.vpc_cidr, 6, 4),
    cidrsubnet(local.vpc_cidr, 6, 5),
    cidrsubnet(local.vpc_cidr, 6, 6),
  ]

  database_subnets = [
    cidrsubnet(local.vpc_cidr, 6, 7),
    cidrsubnet(local.vpc_cidr, 6, 8),
    cidrsubnet(local.vpc_cidr, 6, 9),
  ]

  environment = "sm-mlops-test"

  region = "us-east-1"

  vpc_cidr = "10.10.0.0/24"

  vpc_route_tables = flatten([module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])
}

variable "tags" {
  type    = map(string)
  default = {
    team: "mlops",
    usage: "sagemaker",
    lob: "sbox",
    appid: "APP-xxxx"
  }
}