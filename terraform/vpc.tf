module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.14.2"

  azs                                             = local.availability_zones
  cidr                                            = local.vpc_cidr
  create_database_subnet_group                    = false
  create_flow_log_cloudwatch_iam_role             = true
  create_flow_log_cloudwatch_log_group            = true
  database_subnets                                = local.database_subnets
  enable_dhcp_options                             = true
  enable_dns_hostnames                            = true
  enable_dns_support                              = true
  enable_flow_log                                 = true
  enable_ipv6                                     = true
  enable_nat_gateway                              = true
  flow_log_cloudwatch_log_group_retention_in_days = 7
  flow_log_max_aggregation_interval               = 60
  name                                            = local.environment
  one_nat_gateway_per_az                          = false
  private_subnet_suffix                           = "private"
  private_subnets                                 = local.private_subnets
  public_subnets                                  = local.public_subnets
  single_nat_gateway                              = true
  tags                                            = var.tags
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 3.14.2"

  vpc_id = module.vpc.vpc_id
  tags   = var.tags

  endpoints = {
    s3 = {
      route_table_ids = local.vpc_route_tables
      service         = "s3"
      service_type    = "Gateway"
      tags            = { Name = "s3-vpc-endpoint" }
    },
    ec2 = {
      service             = "ec2"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      security_group_ids  = [aws_security_group.vpc_endpoint.id]
      tags                = { Name = "ec2-vpc-endpoint" }
    }
  }
}

resource "aws_security_group" "vpc_endpoint" {
  name        = "vpc_endpoint"
  description = "VPC endpoint security group allowing traffic for VPC CIDR"
  vpc_id      = module.vpc.vpc_id

  tags = var.tags
}

resource "aws_security_group_rule" "vpc_endpoint_egress" {
  from_port         = 0
  protocol          = -1
  security_group_id = aws_security_group.vpc_endpoint.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = [local.vpc_cidr]
}

resource "aws_security_group_rule" "vpc_endpoint_ingress" {
  from_port         = 0
  protocol          = -1
  security_group_id = aws_security_group.vpc_endpoint.id
  to_port           = 0
  type              = "ingress"
  cidr_blocks       = [local.vpc_cidr]
}