# Just Supporting Infrastructures

data "aws_availability_zones" "available" {}

locals {
  prefix = "easy-fargate-alb"

  vpc_cidr       = "10.0.0.0/16"
  discovered_azs = data.aws_availability_zones.available.names
  vpc_azs        = length(var.availability_zones) == 0 ? local.discovered_azs : var.availability_zones
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

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

module "task_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name   = "${local.prefix}-task-sg"
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
      name             = "${local.prefix}-app"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "ip"
    },
  ]
}

# This module usage starts here
module "ecs_cluster" {
  source = "../../.."

  name = "${local.prefix}-cluster"
}

module "easy_fargate" {
  source = "../../../modules/simple/fargate"

  name                         = "${local.prefix}-service"
  cluster                      = module.ecs_cluster.name
  cpu                          = 256
  memory                       = 512
  desired_count                = 3
  ignore_desired_count_changes = false

  security_groups  = [module.task_security_group.security_group_id]
  vpc_subnets      = module.vpc.public_subnets
  assign_public_ip = true

  # Workaround when destroy fails
  target_group_arn = length(module.alb.target_group_arns) == 0 ? "" : module.alb.target_group_arns[0]
  # container_name must be the same with the name defined in container_definitions!
  container_name = "${local.prefix}-cont"
  container_port = 80

  container_definitions = templatefile("../../templates/container_definitions.tpl", {
    name   = "${local.prefix}-cont"
    cpu    = 256
    memory = 512
  })
}
