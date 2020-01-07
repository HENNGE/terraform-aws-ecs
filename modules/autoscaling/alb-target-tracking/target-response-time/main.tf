resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = var.name
  resource_id        = var.scalable_target_resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = var.target_value
    disable_scale_in   = var.disable_scale_in
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown

    customized_metric_specification {
      metric_name = "TargetResponseTime"
      namespace   = "AWS/ApplicationELB"
      statistic   = var.statistic

      dimensions = [
        {
          name  = "LoadBalancer"
          value = var.alb_arn_suffix
        },
        {
          name  = "TargetGroup"
          value = var.target_group_arn_suffix
        },
      ]

      unit = var.units
    }
  }
}
