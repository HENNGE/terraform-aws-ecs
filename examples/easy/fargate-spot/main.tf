# Just Supporting Infrastructures

data "aws_availability_zones" "available" {}

locals {
  prefix = "easy-fargate-spot"

  vpc_cidr = "10.0.0.0/16"
  vpc_azs  = data.aws_availability_zones.available.names
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.18.0"

  name = "${local.prefix}-vpc"
  cidr = local.vpc_cidr
  azs  = local.vpc_azs

  public_subnets = [for i in range(length(local.vpc_azs)) : cidrsubnet(local.vpc_cidr, 8, i)]

  enable_nat_gateway               = false
  enable_dhcp_options              = true
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]

  enable_ipv6                                   = true
  assign_ipv6_address_on_creation               = true
  public_subnet_assign_ipv6_address_on_creation = true
  public_subnet_ipv6_prefixes                   = range(length(local.vpc_azs))
}

module "task_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.2.0"

  name   = "${local.prefix}-task-sg"
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

# This module usage starts here
module "ecs_cluster" {
  source = "../../.."

  name = "${local.prefix}-cluster"
}

module "easy_fargate" {
  source = "../../../modules/simple/fargate-spot"

  name                         = "${local.prefix}-service"
  cluster                      = module.ecs_cluster.name
  cpu                          = 256
  memory                       = 512
  desired_count                = 2
  ignore_desired_count_changes = false
  num_of_task_on_demand        = 1

  security_groups  = [module.task_security_group.this_security_group_id]
  vpc_subnets      = module.vpc.public_subnets
  assign_public_ip = true

  container_definitions = templatefile("../../templates/container_definitions.tpl", {
    name   = "${local.prefix}-cont"
    cpu    = 256
    memory = 512
  })
}
