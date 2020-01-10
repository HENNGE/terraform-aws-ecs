provider "aws" {
  version = "~> 2"
}

data "aws_availability_zones" "available" {}

locals {
  prefix = "complete-ecs"

  vpc_cidr       = "10.0.0.0/16"
  discovered_azs = data.aws_availability_zones.available.names
  vpc_azs        = length(var.availability_zones) == 0 ? local.discovered_azs : var.availability_zones
}

module "ecs_cluster" {
  source = "../.."

  name = "${local.prefix}-cluster"
}

module "easy_ec2" {
  source = "../../modules/simple/ec2"

  name                         = "${local.prefix}-ec2"
  cluster                      = module.ecs_cluster.name
  cpu                          = 128
  memory                       = 128
  desired_count                = 3
  ignore_desired_count_changes = false

  # Workaround when destroy fails
  target_group_arn = length(module.alb.target_group_arns) == 0 ? "" : module.alb.target_group_arns[0]
  # container_name must be the same with the name defined in container_definitions!
  container_name = "${local.prefix}-cont"
  # Exposed container port, same as in `containerPort` in container_definitions
  container_port = 80

  container_definitions = templatefile("../templates/container_definitions_ec2_dynamic.tpl", {
    name   = "${local.prefix}-cont"
    cpu    = 128
    memory = 128
  })
}

module "easy_fargate" {
  source = "../../modules/simple/fargate"

  name                         = "${local.prefix}-fargate"
  cluster                      = module.ecs_cluster.name
  cpu                          = 256
  memory                       = 512
  desired_count                = 3
  ignore_desired_count_changes = false

  security_groups  = [module.ecs_security_group.this_security_group_id]
  vpc_subnets      = module.vpc.public_subnets
  assign_public_ip = true

  # Workaround when destroy fails
  target_group_arn = length(module.alb.target_group_arns) == 0 ? "" : module.alb.target_group_arns[1]
  # container_name must be the same with the name defined in container_definitions!
  container_name = "${local.prefix}-cont"
  container_port = 80

  container_definitions = templatefile("../templates/container_definitions.tpl", {
    name   = "${local.prefix}-cont"
    cpu    = 256
    memory = 512
  })
}
