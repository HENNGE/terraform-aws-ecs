# ASG Autoscaling
module "asg_autoscaling" {
  source = "../../modules/autoscaling/asg-target-tracking/ecs-reservation"

  name                   = "${local.prefix}-autoscale"
  autoscaling_group_name = module.asg.autoscaling_group_id
  ecs_cluster_name       = module.ecs_cluster.name

  enable_cpu_based_autoscaling = true
  cpu_threshold                = 50
}


module "ec2_service_autoscaling_target" {
  source = "../../modules/core/ecs-autoscaling-target"

  ecs_cluster_name = module.ecs_cluster.name
  ecs_service_name = module.easy_ec2.name
  min_capacity     = module.easy_ec2.desired_count
  max_capacity     = module.easy_ec2.desired_count * 4
}

module "fargate_service_autoscaling_target" {
  source = "../../modules/core/ecs-autoscaling-target"

  ecs_cluster_name = module.ecs_cluster.name
  ecs_service_name = module.easy_fargate.name
  min_capacity     = module.easy_fargate.desired_count
  max_capacity     = module.easy_fargate.desired_count * 4
}

# Autoscales to keep request per target at 10 requests
module "ec2_target_request_autoscaling" {
  source = "../../modules/autoscaling/alb-target-tracking/target-requests-count"

  name                        = "${local.prefix}-ec2-autoscaling"
  alb_arn_suffix              = module.alb.this_lb_arn_suffix
  scalable_target_resource_id = module.ec2_service_autoscaling_target.resource_id
  target_group_arn_suffix     = module.alb.target_group_arn_suffixes[0]
  target_value                = 10
}

module "fargate_target_request_autoscaling" {
  source = "../../modules/autoscaling/alb-target-tracking/target-requests-count"

  name                        = "${local.prefix}-fargate-autoscaling"
  alb_arn_suffix              = module.alb.this_lb_arn_suffix
  scalable_target_resource_id = module.fargate_service_autoscaling_target.resource_id
  target_group_arn_suffix     = module.alb.target_group_arn_suffixes[1]
  target_value                = 10
}
