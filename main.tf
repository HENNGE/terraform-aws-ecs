resource "aws_ecs_cluster" "main" {
  name = var.name

  capacity_providers = var.capacity_providers

  dynamic "default_capacity_provider_strategy" {
    for_each = var.default_capacity_provider_strategy
    content {
      capacity_provider = lookup(default_capacity_provider_strategy.value, "capacity_provider", null)
      weight            = lookup(default_capacity_provider_strategy.value, "weight", null)
      base              = lookup(default_capacity_provider_strategy.value, "base", null)
    }
  }

  dynamic "setting" {
    for_each = var.settings
    content {
      name  = lookup(setting.value, "name", null)
      value = lookup(setting.value, "value", null)
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}
