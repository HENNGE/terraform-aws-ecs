# Just Supporting Infrastructures

data "aws_availability_zones" "available" {}

data "aws_ssm_parameter" "ami_image" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

locals {
  prefix = "easy-ec2"

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

module "ec2_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name   = "${local.prefix}-ec2-sg"
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

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.0"

  name = "${local.prefix}-asg"

  image_id                    = data.aws_ssm_parameter.ami_image.value
  instance_type               = "t2.micro"
  security_groups             = [module.ec2_security_group.security_group_id]
  vpc_zone_identifier         = module.vpc.public_subnets
  min_size                    = 1
  max_size                    = 2
  desired_capacity            = 1
  health_check_type           = "EC2"
  associate_public_ip_address = true
  user_data = templatefile("../../templates/ec2_userdata.tpl", {
    ecs_cluster = module.ecs_cluster.name
  })
  iam_instance_profile_arn = var.instance_profile_arn
}

# This module usage starts here
module "ecs_cluster" {
  source = "../../.."

  name = "${local.prefix}-cluster"
}

module "easy_ec2" {
  source = "../../../modules/simple/ec2"

  name                         = "${local.prefix}-service"
  cluster                      = module.ecs_cluster.name
  cpu                          = 256
  memory                       = 512
  desired_count                = 1
  ignore_desired_count_changes = false

  network_mode = "host"

  container_definitions = templatefile("../../templates/container_definitions.tpl", {
    name   = "${local.prefix}-cont"
    cpu    = 256
    memory = 512
  })
}
