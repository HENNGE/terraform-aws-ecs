resource "aws_ecs_cluster" "main" {
  name = var.name

  dynamic "setting" {
    for_each = var.settings
    content {
      name  = lookup(setting.value, "name", null)
      value = lookup(setting.value, "value", null)
    }
  }

  dynamic "setting" {
    for_each = var.enable_container_insights ? [1] : []
    content {
      name  = "containerInsights"
      value = "enabled"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_ecs_cluster_capacity_providers" "capacity_provider" {
  count = var.capacity_providers != null || var.default_capacity_provider_strategy != [] ? 1 : 0

  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = var.capacity_providers

  dynamic "default_capacity_provider_strategy" {
    for_each = var.default_capacity_provider_strategy
    content {
      capacity_provider = lookup(default_capacity_provider_strategy.value, "capacity_provider", null)
      weight            = lookup(default_capacity_provider_strategy.value, "weight", null)
      base              = lookup(default_capacity_provider_strategy.value, "base", null)
    }
  }
}
