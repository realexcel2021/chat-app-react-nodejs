# VPC, subnets, NAT gateway, IGW, db subnet group

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project_name}-VPC"
  cidr = var.vpc_cidr

  azs                        = var.azs
  private_subnets            = var.private_subnets
  public_subnets             = var.public_subnets
  database_subnets           = var.database_subnets
  database_subnet_group_name = var.database_subnet_group_name
  single_nat_gateway         = true

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags                = var.tags
  public_subnet_tags  = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags
}

