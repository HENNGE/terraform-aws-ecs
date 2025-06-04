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
    for_each = var.alarms == null ? [] : [var.alarms]

    content {
      alarm_names = alarms.value.alarm_names
      enable      = alarms.value.enable
      rollback    = alarms.value.rollback
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
      enabled = service_connect_configuration.value.enabled
      dynamic "log_configuration" {
        for_each = service_connect_configuration.value.log_configuration == null ? [] : [service_connect_configuration.value.log_configuration]

        content {
          log_driver = log_configuration.value.log_driver
          options    = log_configuration.value.options
          dynamic "secret_option" {
            for_each = log_configuration.value.secret_option == null ? [] : [log_configuration.value.secret_option]

            content {
              name       = secret_option.value.name
              value_from = secret_option.value.value_from
            }
          }
        }
      }
      namespace = service_connect_configuration.value.namespace
      dynamic "service" {
        for_each = service_connect_configuration.value.service == null ? [] : [service_connect_configuration.value.service]

        content {
          dynamic "client_alias" {
            for_each = service.value.client_alias

            content {
              dns_name = client_alias.value.dns_name
              port     = client_alias.value.port
            }
          }
          discovery_name        = service.value.discovery_name
          ingress_port_override = service.value.ingress_port_override
          port_name             = service.value.port_name

          dynamic "timeout" {
            for_each = service.value.timeout == null ? [] : [service.value.timeout]

            content {
              idle_timeout_seconds        = timeout.value.idle_timeout_seconds
              per_request_timeout_seconds = timeout.value.per_request_timeout_seconds
            }
          }

          dynamic "tls" {
            for_each = service.value.tls == null ? [] : [service.value.tls]

            content {
              dynamic "issuer_cert_authority" {
                for_each = tls.value.issuer_cert_authority == null ? [] : [tls.value.issuer_cert_authority]

                content {
                  aws_pca_authority_arn = issuer_cert_authority.value.aws_pca_authority_arn
                }
              }
              kms_key  = tls.value.kms_key
              role_arn = tls.value.role_arn
            }
          }
        }
      }
    }
  }

  dynamic "volume_configuration" {
    for_each = var.volume_configuration

    content {
      name = volume_configuration.value.name
      dynamic "managed_ebs_volume" {
        for_each = volume_configuration.value.managed_ebs_volume == null ? [] : [volume_configuration.value.managed_ebs_volume]

        content {
          role_arn         = managed_ebs_volume.value.role_arn
          encrypted        = managed_ebs_volume.value.encrypted
          file_system_type = managed_ebs_volume.value.file_system_type
          iops             = managed_ebs_volume.value.iops
          kms_key_id       = managed_ebs_volume.value.kms_key_id
          size_in_gb       = managed_ebs_volume.value.size_in_gb
          snapshot_id      = managed_ebs_volume.value.snapshot_id
          throughput       = managed_ebs_volume.value.throughput
          volume_type      = managed_ebs_volume.value.volume_type
          dynamic "tag_specifications" {
            for_each = managed_ebs_volume.value.tag_specifications

            content {
              resource_type  = tag_specifications.value.resource_type
              propagate_tags = tag_specifications.value.propagate_tags
              tags           = tag_specifications.value.tags
            }
          }
        }
      }
    }
  }

  dynamic "vpc_lattice_configurations" {
    for_each = var.vpc_lattice_configurations
    content {
      role_arn         = vpc_lattice_configurations.value.role_arn
      target_group_arn = vpc_lattice_configurations.value.target_group_arn
      port_name        = vpc_lattice_configurations.value.port_name
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
    for_each = var.alarms == null ? [] : [var.alarms]

    content {
      alarm_names = alarms.value.alarm_names
      enable      = alarms.value.enable
      rollback    = alarms.value.rollback
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
      enabled = service_connect_configuration.value.enabled
      dynamic "log_configuration" {
        for_each = service_connect_configuration.value.log_configuration == null ? [] : [service_connect_configuration.value.log_configuration]

        content {
          log_driver = log_configuration.value.log_driver
          options    = log_configuration.value.options
          dynamic "secret_option" {
            for_each = log_configuration.value.secret_option == null ? [] : [log_configuration.value.secret_option]

            content {
              name       = secret_option.value.name
              value_from = secret_option.value.value_from
            }
          }
        }
      }
      namespace = service_connect_configuration.value.namespace
      dynamic "service" {
        for_each = service_connect_configuration.value.service == null ? [] : [service_connect_configuration.value.service]

        content {
          dynamic "client_alias" {
            for_each = service.value.client_alias

            content {
              dns_name = client_alias.value.dns_name
              port     = client_alias.value.port
            }
          }
          discovery_name        = service.value.discovery_name
          ingress_port_override = service.value.ingress_port_override
          port_name             = service.value.port_name

          dynamic "timeout" {
            for_each = service.value.timeout == null ? [] : [service.value.timeout]

            content {
              idle_timeout_seconds        = timeout.value.idle_timeout_seconds
              per_request_timeout_seconds = timeout.value.per_request_timeout_seconds
            }
          }

          dynamic "tls" {
            for_each = service.value.tls == null ? [] : [service.value.tls]

            content {
              dynamic "issuer_cert_authority" {
                for_each = tls.value.issuer_cert_authority == null ? [] : [tls.value.issuer_cert_authority]

                content {
                  aws_pca_authority_arn = issuer_cert_authority.value.aws_pca_authority_arn
                }
              }
              kms_key  = tls.value.kms_key
              role_arn = tls.value.role_arn
            }
          }
        }
      }
    }
  }

  dynamic "volume_configuration" {
    for_each = var.volume_configuration

    content {
      name = volume_configuration.value.name
      dynamic "managed_ebs_volume" {
        for_each = volume_configuration.value.managed_ebs_volume == null ? [] : [volume_configuration.value.managed_ebs_volume]

        content {
          role_arn         = managed_ebs_volume.value.role_arn
          encrypted        = managed_ebs_volume.value.encrypted
          file_system_type = managed_ebs_volume.value.file_system_type
          iops             = managed_ebs_volume.value.iops
          kms_key_id       = managed_ebs_volume.value.kms_key_id
          size_in_gb       = managed_ebs_volume.value.size_in_gb
          snapshot_id      = managed_ebs_volume.value.snapshot_id
          throughput       = managed_ebs_volume.value.throughput
          volume_type      = managed_ebs_volume.value.volume_type
          dynamic "tag_specifications" {
            for_each = managed_ebs_volume.value.tag_specifications

            content {
              resource_type  = tag_specifications.value.resource_type
              propagate_tags = tag_specifications.value.propagate_tags
              tags           = tag_specifications.value.tags
            }
          }
        }
      }
    }
  }

  dynamic "vpc_lattice_configurations" {
    for_each = var.vpc_lattice_configurations
    content {
      role_arn         = vpc_lattice_configurations.value.role_arn
      target_group_arn = vpc_lattice_configurations.value.target_group_arn
      port_name        = vpc_lattice_configurations.value.port_name
    }
  }

  tags = var.tags
}

module "task" {
  source                   = "../task"
  create_task_definition   = var.create_task_definition
  name                     = var.name
  container_definitions    = var.container_definitions
  network_mode             = var.task_network_mode
  ipc_mode                 = var.task_ipc_mode
  pid_mode                 = var.task_pid_mode
  skip_destroy             = var.task_skip_destroy
  task_role                = var.iam_task_role
  daemon_role              = var.iam_daemon_role
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  enable_fault_injection   = var.task_enable_fault_injection
  ephemeral_storage        = var.task_ephemeral_storage
  requires_compatibilities = var.task_requires_compatibilities
  volume_configurations    = var.task_volume_configurations
  placement_constraints    = var.task_placement_constraints
  inference_accelerator    = var.task_inference_accelerator
  proxy_configuration      = var.task_proxy_configuration
  runtime_platform         = var.task_runtime_platform
  track_latest             = var.task_track_latest
  tags                     = var.tags
}
