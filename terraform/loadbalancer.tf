# load balancer for the backend service

module "alb-backend" {
  source = "terraform-aws-modules/alb/aws"

  name    = "snappy-backend-lb"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  create_security_group = false
  security_groups = [ module.backend-lb.security_group_id ]
  enable_deletion_protection = false

  listeners = {
    http-backend-redirect = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "backend-tg"
      }
    }
  }

  target_groups = {
    backend-tg = {
      protocol         = "HTTP"
      port             = 3000
      target_type      = "ip"
      create_attachment = false

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }
    }
  }

  tags = var.tags
}