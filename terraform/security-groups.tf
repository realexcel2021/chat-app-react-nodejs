
# get prefix lists for cloudfront to backend sg
data "aws_ec2_managed_prefix_list" "cloudfront" {
 name = "com.amazonaws.global.cloudfront.origin-facing"
}

# security group for the backend load balancer

module "backend-lb" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "snappy-lb-sg"
  description = "Security group for backend loadbalancer allows only traffic from cloudfront"
  vpc_id      = module.vpc.vpc_id

  ingress_prefix_list_ids = [ data.aws_ec2_managed_prefix_list.cloudfront.id ]

  ingress_with_cidr_blocks = [
    {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      description     = "Arbitrary TCP port"
      prefix_list_ids = data.aws_ec2_managed_prefix_list.cloudfront.id 
    },
  ]
}

module "ecs_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "snappy-database-sg"
  description = "Security group for ecs allows only traffic from loadbalancer"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 3000
      to_port                  = 3000
      protocol                 = "tcp"
      description              = "backend tasks rule"
      source_security_group_id = module.backend-lb.security_group_id
    },
  ]
}

# security group for the document db

module "db_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "snappy-database-sg"
  description = "Security group for ecs backend allows only traffic from cloudfront"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 27017
      to_port                  = 27017
      protocol                 = "tcp"
      description              = "Document db rule"
      source_security_group_id = module.ecs_sg.security_group_id
    },
  ]
}