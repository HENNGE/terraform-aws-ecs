module "fargate" {
  source = "../../core/service"

  name                         = var.name
  cluster                      = var.cluster
  container_definitions        = var.container_definitions
  desired_count                = var.desired_count
  ignore_desired_count_changes = var.ignore_desired_count_changes

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
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds

  task_requires_compatibilites = ["FARGATE"]

  task_network_mode = "awsvpc"
  network_configuration = {
    subnets          = var.vpc_subnets
    security_groups  = var.security_groups
    assign_public_ip = var.assign_public_ip
  }

  task_volume_configurations = var.volume_configurations
  task_proxy_configuration   = var.proxy_configuration
  service_registry           = var.service_registry

  platform_version = var.platform_version

  capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE_SPOT"
      weight            = 1
    },
    {
      capacity_provider = "FARGATE"
      weight            = 0
      base              = var.num_of_task_on_demand
    }
  ]

  tags = var.tags
}