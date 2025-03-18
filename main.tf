locals {
  create_capacity_provider = var.capacity_providers != null || length(var.default_capacity_provider_strategy) > 0
}

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
      value = var.container_insights_enhanced ? "enhanced" : "enabled"
    }
  }

  dynamic "configuration" {
    for_each = var.execute_command_configuration != null ? [1] : []

    content {
      dynamic "execute_command_configuration" {
        for_each = [var.execute_command_configuration]

        content {
          kms_key_id = try(execute_command_configuration.value.kms_key_id, null)
          logging    = try(execute_command_configuration.value.logging, null)

          dynamic "log_configuration" {
            for_each = try([execute_command_configuration.value.log_configuration], [])

            content {
              cloud_watch_encryption_enabled = try(log_configuration.value.cloud_watch_encryption_enabled, null)
              cloud_watch_log_group_name     = try(log_configuration.value.cloud_watch_log_group_name, null)
              s3_bucket_name                 = try(log_configuration.value.s3_bucket_name, null)
              s3_bucket_encryption_enabled   = try(log_configuration.value.s3_bucket_encryption_enabled, null)
              s3_key_prefix                  = try(log_configuration.value.s3_key_prefix, null)
            }
          }
        }
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  count = local.create_capacity_provider ? 1 : 0

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
