resource "aws_ecs_task_definition" "main" {
  count                 = var.create_task_definition ? 1 : 0
  family                = var.name
  container_definitions = var.container_definitions

  task_role_arn      = var.task_role
  execution_role_arn = var.daemon_role

  network_mode = var.network_mode
  ipc_mode     = var.ipc_mode
  pid_mode     = var.pid_mode

  cpu    = var.cpu
  memory = var.memory

  requires_compatibilities = var.requires_compatibilites

  dynamic "volume" {
    for_each = var.volume_configurations
    content {
      name      = lookup(volume.value, "name", null)
      host_path = lookup(volume.value, "host_path", null)
      dynamic "docker_volume_configuration" {
        for_each = lookup(volume.value, "docker_volume_configuration", null) == null ? [] : [volume.value["docker_volume_configuration"]]
        content {
          scope         = lookup(docker_volume_configuration.value, "scope", null)
          autoprovision = lookup(docker_volume_configuration.value, "autoprovision", null)
          driver        = lookup(docker_volume_configuration.value, "driver", null)
          driver_opts   = lookup(docker_volume_configuration.value, "driver_opts", null)
          labels        = lookup(docker_volume_configuration.value, "labels", null)
        }
      }
      dynamic "efs_volume_configuration" {
        for_each = lookup(volume.value, "efs_volume_configuration", null) == null ? [] : [volume.value["efs_volume_configuration"]]
        content {
          file_system_id          = lookup(efs_volume_configuration.value, "file_system_id", null)
          root_directory          = lookup(efs_volume_configuration.value, "root_directory", null)
          transit_encryption      = lookup(efs_volume_configuration.value, "transit_encryption", "ENABLED")
          transit_encryption_port = lookup(efs_volume_configuration.value, "transit_encryption_port", null)
          dynamic "authorization_config" {
            for_each = lookup(efs_volume_configuration.value, "authorization_config", null) == null ? [] : [efs_volume_configuration.value["authorization_config"]]
            content {
              access_point_id = lookup(authorization_config.value, "access_point_id", null)
              iam             = lookup(authorization_config.value, "iam", "DISABLED")
            }
          }
        }
      }
    }
  }

  dynamic "placement_constraints" {
    for_each = var.placement_constraints
    content {
      type       = lookup(placement_constraints.value, "type", null)
      expression = lookup(placement_constraints.value, "expression", null)
    }
  }

  dynamic "proxy_configuration" {
    for_each = var.proxy_configuration == null ? [] : [var.proxy_configuration]
    content {
      type           = lookup(proxy_configuration.value, "type", null)
      container_name = lookup(proxy_configuration.value, "container_name", null)
      properties     = lookup(proxy_configuration.value, "properties", null)
    }
  }

  dynamic "inference_accelerator" {
    for_each = var.inference_accelerator
    content {
      device_name = lookup(inference_accelerator.value, "device_name", null)
      device_type = lookup(inference_accelerator.value, "device_type", null)
    }
  }

  dynamic "runtime_platform" {
    for_each = var.runtime_platform == null ? [] : [var.runtime_platform]
    content {
      operating_system_family = lookup(runtime_platform.value, "operating_system_family", null)
      cpu_architecture        = lookup(runtime_platform.value, "cpu_architecture", null)
    }
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}
