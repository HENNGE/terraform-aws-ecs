##########################################################
# ECS Service that does not ignore `desired_count` changes
##########################################################

resource "aws_ecs_service" "main" {
  count = var.ignore_desired_count_changes ? 0 : 1

  name                               = var.name
  cluster                            = var.cluster
  task_definition                    = var.create_task_definition ? module.task.arn : var.task_definition_arn
  availability_zone_rebalancing      = var.availability_zone_rebalancing
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  desired_count                      = var.desired_count
  enable_ecs_managed_tags            = var.enable_ecs_managed_tags
  enable_execute_command             = var.enable_execute_command
  force_delete                       = var.force_delete
  force_new_deployment               = var.force_new_deployment
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  iam_role                           = var.iam_lb_role
  launch_type                        = var.launch_type
  platform_version                   = var.platform_version
  propagate_tags                     = var.propagate_tags
  scheduling_strategy                = var.scheduling_strategy
  wait_for_steady_state              = var.wait_for_steady_state

  deployment_controller {
    type = var.deployment_controller
  }

  dynamic "alarms" {
    for_each = length(var.alarms) > 0 ? [var.alarms] : []

    content {
      alarm_names = alarms.value.alarm_names
      enable      = lookup(alarms.value.enable, null)
      rollback    = lookup(alarms.value.rollback, null)
    }
  }

  dynamic "deployment_circuit_breaker" {
    for_each = var.enable_deployment_circuit_breaker_with_rollback || var.enable_deployment_circuit_breaker_without_rollback ? [1] : []
    content {
      enable   = var.enable_deployment_circuit_breaker_with_rollback || var.enable_deployment_circuit_breaker_without_rollback
      rollback = var.enable_deployment_circuit_breaker_with_rollback
    }
  }

  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider_strategy
    content {
      capacity_provider = lookup(capacity_provider_strategy.value, "capacity_provider", null)
      weight            = lookup(capacity_provider_strategy.value, "weight", null)
      base              = lookup(capacity_provider_strategy.value, "base", null)
    }
  }

  dynamic "load_balancer" {
    for_each = var.load_balancers
    content {
      elb_name         = lookup(load_balancer.value, "elb_name", null)
      target_group_arn = lookup(load_balancer.value, "target_group_arn", null)
      container_name   = lookup(load_balancer.value, "container_name", null)
      container_port   = lookup(load_balancer.value, "container_port", null)
    }
  }

  dynamic "network_configuration" {
    for_each = var.network_configuration == null ? [] : [var.network_configuration]
    content {
      subnets          = lookup(network_configuration.value, "subnets", null)
      security_groups  = lookup(network_configuration.value, "security_groups", null)
      assign_public_ip = lookup(network_configuration.value, "assign_public_ip", null)
    }
  }

  dynamic "ordered_placement_strategy" {
    for_each = var.ordered_placement_strategy
    content {
      type  = lookup(ordered_placement_strategy.value, "type", null)
      field = lookup(ordered_placement_strategy.value, "field", null)
    }
  }

  dynamic "placement_constraints" {
    for_each = var.service_placement_constraints
    content {
      type       = lookup(placement_constraints.value, "type", null)
      expression = lookup(placement_constraints.value, "expression", null)
    }
  }

  dynamic "service_registries" {
    for_each = var.service_registry == null ? [] : [var.service_registry]
    content {
      registry_arn   = lookup(service_registries.value, "registry_arn", null)
      port           = lookup(service_registries.value, "port", null)
      container_port = lookup(service_registries.value, "container_port", null)
      container_name = lookup(service_registries.value, "container_name", null)
    }
  }

  dynamic "service_connect_configuration" {
    for_each = var.service_connect_configuration == null ? [] : [var.service_connect_configuration]

    content {
      enabled = lookup(service_connect_configuration.value, "enabled", null)

      dynamic "log_configuration" {
        for_each = var.service_connect_configuration.log_configuration == null ? [] : [var.service_connect_configuration.log_configuration]

        content {
          log_driver = lookup(log_configuration.value, "log_driver", null)
          options    = lookup(log_configuration.value, "options", null)

          dynamic "secret_option" {
            for_each = log_configuration.value.secret_option == null ? [] : [log_configuration.value.secret_option]

            content {
              name       = secret_option.value.name
              value_from = secret_option.value.value_from
            }
          }
        }
      }

      namespace = lookup(service_connect_configuration.value, "namespace", null)

      dynamic "service" {
        for_each = var.service_connect_configuration.service == null ? [] : [var.service_connect_configuration.service]

        content {
          dynamic "client_alias" {
            for_each = service.value.client_alias == null ? [] : [service.value.client_alias]

            content {
              dns_name = lookup(client_alias.value, "dns_name", null)
              port     = client_alias.value.port
            }
          }

          discovery_name        = lookup(service.value, "discovery_name", null)
          ingress_port_override = lookup(service.value, "ingress_port_override", null)
          port_name             = lookup(service.value, "port_name", null)
        }
      }
    }
  }

  dynamic "vpc_lattice_configurations" {
    for_each = var.vpc_lattice_configurations
    content {
      role_arn         = var.vpc_lattice_configurations.role_arn
      target_group_arn = var.vpc_lattice_configurations.target_group_arn
      port_name        = var.vpc_lattice_configurations.port_name
    }
  }

  tags = var.tags
}

###########################################################
# ECS Service that does not ignore `desired_count` changes
# Basically same with above, only `count` and `lifecycle`
# parameters are different since terraform does not support
# dynamic lifecycle definition
###########################################################

resource "aws_ecs_service" "main_ignore_desired_count_changes" {
  count = var.ignore_desired_count_changes ? 1 : 0

  lifecycle {
    ignore_changes = [desired_count]
  }

  name                               = var.name
  cluster                            = var.cluster
  task_definition                    = var.create_task_definition ? module.task.arn : var.task_definition_arn
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  desired_count                      = var.desired_count
  enable_ecs_managed_tags            = var.enable_ecs_managed_tags
  enable_execute_command             = var.enable_execute_command
  force_new_deployment               = var.force_new_deployment
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  iam_role                           = var.iam_lb_role
  launch_type                        = var.launch_type
  platform_version                   = var.platform_version
  propagate_tags                     = var.propagate_tags
  scheduling_strategy                = var.scheduling_strategy
  wait_for_steady_state              = var.wait_for_steady_state

  deployment_controller {
    type = var.deployment_controller
  }

  dynamic "alarms" {
    for_each = length(var.alarms) > 0 ? [var.alarms] : []

    content {
      alarm_names = alarms.value.alarm_names
      enable      = lookup(alarms.value.enable, null)
      rollback    = lookup(alarms.value.rollback, null)
    }
  }

  dynamic "deployment_circuit_breaker" {
    for_each = var.enable_deployment_circuit_breaker_with_rollback || var.enable_deployment_circuit_breaker_without_rollback ? [1] : []
    content {
      enable   = var.enable_deployment_circuit_breaker_with_rollback || var.enable_deployment_circuit_breaker_without_rollback
      rollback = var.enable_deployment_circuit_breaker_with_rollback
    }
  }

  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider_strategy
    content {
      capacity_provider = lookup(capacity_provider_strategy.value, "capacity_provider", null)
      weight            = lookup(capacity_provider_strategy.value, "weight", null)
      base              = lookup(capacity_provider_strategy.value, "base", null)
    }
  }

  dynamic "load_balancer" {
    for_each = var.load_balancers
    content {
      elb_name         = lookup(load_balancer.value, "elb_name", null)
      target_group_arn = lookup(load_balancer.value, "target_group_arn", null)
      container_name   = lookup(load_balancer.value, "container_name", null)
      container_port   = lookup(load_balancer.value, "container_port", null)
    }
  }

  dynamic "network_configuration" {
    for_each = var.network_configuration == null ? [] : [var.network_configuration]
    content {
      subnets          = lookup(network_configuration.value, "subnets", null)
      security_groups  = lookup(network_configuration.value, "security_groups", null)
      assign_public_ip = lookup(network_configuration.value, "assign_public_ip", null)
    }
  }

  dynamic "ordered_placement_strategy" {
    for_each = var.ordered_placement_strategy
    content {
      type  = lookup(ordered_placement_strategy.value, "type", null)
      field = lookup(ordered_placement_strategy.value, "field", null)
    }
  }

  dynamic "placement_constraints" {
    for_each = var.service_placement_constraints
    content {
      type       = lookup(placement_constraints.value, "type", null)
      expression = lookup(placement_constraints.value, "expression", null)
    }
  }

  dynamic "service_registries" {
    for_each = var.service_registry == null ? [] : [var.service_registry]
    content {
      registry_arn   = lookup(service_registries.value, "registry_arn", null)
      port           = lookup(service_registries.value, "port", null)
      container_port = lookup(service_registries.value, "container_port", null)
      container_name = lookup(service_registries.value, "container_name", null)
    }
  }

  dynamic "service_connect_configuration" {
    for_each = var.service_connect_configuration == null ? [] : [var.service_connect_configuration]

    content {
      enabled = lookup(service_connect_configuration.value, "enabled", null)

      dynamic "log_configuration" {
        for_each = var.service_connect_configuration.log_configuration == null ? [] : [var.service_connect_configuration.log_configuration]

        content {
          log_driver = lookup(log_configuration.value, "log_driver", null)
          options    = lookup(log_configuration.value, "options", null)

          dynamic "secret_option" {
            for_each = log_configuration.value.secret_option == null ? [] : [log_configuration.value.secret_option]

            content {
              name       = secret_option.value.name
              value_from = secret_option.value.value_from
            }
          }
        }
      }

      namespace = lookup(service_connect_configuration.value, "namespace", null)

      dynamic "service" {
        for_each = var.service_connect_configuration.service == null ? [] : [var.service_connect_configuration.service]

        content {
          dynamic "client_alias" {
            for_each = service.value.client_alias == null ? [] : [service.value.client_alias]

            content {
              dns_name = lookup(client_alias.value, "dns_name", null)
              port     = client_alias.value.port
            }
          }

          discovery_name        = lookup(service.value, "discovery_name", null)
          ingress_port_override = lookup(service.value, "ingress_port_override", null)
          port_name             = lookup(service.value, "port_name", null)
        }
      }
    }
  }

  dynamic "vpc_lattice_configurations" {
    for_each = var.vpc_lattice_configurations
    content {
      role_arn         = var.vpc_lattice_configurations.role_arn
      target_group_arn = var.vpc_lattice_configurations.target_group_arn
      port_name        = var.vpc_lattice_configurations.port_name
    }
  }

  tags = var.tags
}

module "task" {
  source                  = "../task"
  create_task_definition  = var.create_task_definition
  name                    = var.name
  container_definitions   = var.container_definitions
  network_mode            = var.task_network_mode
  ipc_mode                = var.task_ipc_mode
  pid_mode                = var.task_pid_mode
  skip_destroy            = var.task_skip_destroy
  task_role               = var.iam_task_role
  daemon_role             = var.iam_daemon_role
  cpu                     = var.task_cpu
  memory                  = var.task_memory
  enable_fault_injection  = var.task_enable_fault_injection
  ephemeral_storage       = var.task_ephemeral_storage
  requires_compatibilites = var.task_requires_compatibilites
  volume_configurations   = var.task_volume_configurations
  placement_constraints   = var.task_placement_constraints
  inference_accelerator   = var.task_inference_accelerator
  proxy_configuration     = var.task_proxy_configuration
  runtime_platform        = var.task_runtime_platform
  track_latest            = var.task_track_latest
  tags                    = var.tags
}
