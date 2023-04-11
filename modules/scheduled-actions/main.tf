resource "aws_cloudwatch_event_rule" "rule" {
  name                = var.name
  description         = var.schedule_description
  schedule_expression = var.schedule_rule
}

resource "aws_cloudwatch_event_target" "target" {
  rule     = aws_cloudwatch_event_rule.rule.name
  arn      = var.cluster_arn
  role_arn = var.iam_invoker

  ecs_target {
    task_count          = var.task_count
    task_definition_arn = var.task_definition_arn
    launch_type         = var.capacity_provider_strategy == null ? (var.is_fargate ? "FARGATE" : "EC2") : null

    dynamic "network_configuration" {
      for_each = var.is_fargate ? ["yes"] : []
      content {
        subnets          = var.fargate_subnets
        security_groups  = var.fargate_security_groups
        assign_public_ip = var.fargate_assign_public_ip
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
  }

  input = var.container_overrides
}
