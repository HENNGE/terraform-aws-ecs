module "fargate" {
  source = "../../core/service"

  name                         = var.name
  cluster                      = var.cluster
  container_definitions        = var.container_definitions
  desired_count                = var.desired_count
  ignore_desired_count_changes = var.ignore_desired_count_changes
  volume_configuration         = var.volume_configuration

  iam_daemon_role = var.iam_daemon_role
  iam_task_role   = var.iam_task_role
  iam_lb_role     = var.iam_lb_role

  task_cpu    = var.cpu
  task_memory = var.memory

  load_balancers = var.target_group_arn != null || var.elb_name != null ? [
    {
      elb_name         = var.elb_name
      target_group_arn = var.target_group_arn
      container_name   = var.container_name
      container_port   = var.container_port
    }
  ] : []
  force_new_deployment                               = var.force_new_deployment
  deployment_minimum_healthy_percent                 = var.deployment_minimum_healthy_percent
  deployment_maximum_percent                         = var.deployment_maximum_percent
  enable_deployment_circuit_breaker_with_rollback    = var.enable_deployment_circuit_breaker_with_rollback
  enable_deployment_circuit_breaker_without_rollback = var.enable_deployment_circuit_breaker_without_rollback
  health_check_grace_period_seconds                  = var.health_check_grace_period_seconds

  alarms                        = var.alarms
  availability_zone_rebalancing = var.availability_zone_rebalancing
  force_delete                  = var.force_delete
  service_connect_configuration = var.service_connect_configuration

  vpc_lattice_configurations = var.vpc_lattice_configurations

  enable_execute_command = var.enable_execute_command

  launch_type                   = "FARGATE"
  task_requires_compatibilities = ["FARGATE"]

  task_network_mode = "awsvpc"
  network_configuration = {
    subnets          = var.vpc_subnets
    security_groups  = var.security_groups
    assign_public_ip = var.assign_public_ip
  }

  task_volume_configurations  = var.task_volume_configurations
  task_proxy_configuration    = var.proxy_configuration
  task_runtime_platform       = var.runtime_platform
  task_enable_fault_injection = var.enable_fault_injection
  task_ephemeral_storage      = var.ephemeral_storage
  task_skip_destroy           = var.skip_destroy
  task_track_latest           = var.track_latest
  service_registry            = var.service_registry
  task_inference_accelerator  = var.inference_accelerator
  task_placement_constraints  = var.placement_constraints
  ordered_placement_strategy  = var.ordered_placement_strategy

  platform_version = var.platform_version

  enable_ecs_managed_tags = var.enable_ecs_managed_tags
  propagate_tags          = var.propagate_tags

  wait_for_steady_state = var.wait_for_steady_state

  tags = var.tags
}
