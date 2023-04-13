resource "aws_appautoscaling_scheduled_action" "ecs_scheduled_action" {
  name               = var.name
  resource_id        = var.scalable_target_resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  schedule = var.schedule
  timezone = var.timezone

  scalable_target_action {
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity
  }
}
