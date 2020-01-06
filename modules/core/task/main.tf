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

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}
