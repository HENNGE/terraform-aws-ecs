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
    launch_type         = var.is_fargate ? "FARGATE" : "EC2"

    dynamic "network_configuration" {
      for_each = var.is_fargate ? ["yes"] : []
      content {
        subnets          = var.fargate_subnets
        security_groups  = var.fargate_security_groups
        assign_public_ip = var.fargate_assign_public_ip
      }
    }
  }

  input = var.container_overrides
}
