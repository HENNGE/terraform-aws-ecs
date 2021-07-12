data "aws_ssm_parameter" "ami_image" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2"

  name = "${local.prefix}-vpc"
  cidr = local.vpc_cidr
  azs  = local.vpc_azs

  public_subnets = [for i in range(length(local.vpc_azs)) : cidrsubnet(local.vpc_cidr, 8, i)]

  enable_nat_gateway               = false
  enable_dhcp_options              = true
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]

  enable_ipv6                                   = var.enable_ipv6
  assign_ipv6_address_on_creation               = var.enable_ipv6
  public_subnet_assign_ipv6_address_on_creation = var.enable_ipv6
  public_subnet_ipv6_prefixes                   = range(length(local.vpc_azs))
}

module "alb_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name   = "${local.prefix}-alb-sg"
  vpc_id = module.vpc.vpc_id

  # Ingress for HTTP
  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_ipv6_cidr_blocks = ["::/0"]
  ingress_rules            = ["http-80-tcp"]

  # Allow all egress
  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_ipv6_cidr_blocks = ["::/0"]
  egress_rules            = ["all-all"]
}

module "ecs_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name   = "${local.prefix}-ec2-sg"
  vpc_id = module.vpc.vpc_id


  # Ingress from ALB only
  number_of_computed_ingress_with_source_security_group_id = 1
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.alb_security_group.security_group_id
    }
  ]

  # Allow all egress
  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_ipv6_cidr_blocks = ["::/0"]
  egress_rules            = ["all-all"]
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "5.13.0"

  name               = "${local.prefix}-alb"
  load_balancer_type = "application"
  security_groups    = [module.alb_security_group.security_group_id]
  subnets            = module.vpc.public_subnets
  vpc_id             = module.vpc.vpc_id

  ip_address_type = var.enable_ipv6 ? "dualstack" : "ipv4"

  listener_ssl_policy_default = "ELBSecurityPolicy-2016-08"
  http_tcp_listeners = [
    {
      target_group_index = 0
      port               = 80
      protocol           = "HTTP"
    },
  ]
  target_groups = [
    {
      name             = "${local.prefix}-ec2"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    },
    {
      name             = "${local.prefix}-fargate"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "ip"
    },
  ]
}

resource "aws_lb_listener_rule" "ec2" {
  listener_arn = module.alb.http_tcp_listener_arns[0]
  action {
    type             = "forward"
    target_group_arn = module.alb.target_group_arns[0]
  }
  condition {
    path_pattern {
      values = ["/ec2"]
    }
  }
}

resource "aws_lb_listener_rule" "fargate" {
  listener_arn = module.alb.http_tcp_listener_arns[0]
  action {
    type             = "forward"
    target_group_arn = module.alb.target_group_arns[1]
  }
  condition {
    path_pattern {
      values = ["/fargate"]
    }
  }
}

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = "${local.prefix}-asg"

  image_id                    = data.aws_ssm_parameter.ami_image.value
  instance_type               = "t2.micro"
  security_groups             = [module.ecs_security_group.security_group_id]
  vpc_zone_identifier         = module.vpc.public_subnets
  min_size                    = 1
  max_size                    = 10
  desired_capacity            = 1
  health_check_type           = "EC2"
  associate_public_ip_address = true
  user_data = templatefile("../templates/ec2_userdata.tpl", {
    ecs_cluster = module.ecs_cluster.name
  })
  iam_instance_profile = var.instance_profile_arn
}
