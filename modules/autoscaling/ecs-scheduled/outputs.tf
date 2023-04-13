output "scheduled_action_arn" {
  description = "ARN of the autoscaling scheduled action."
  value       = aws_appautoscaling_scheduled_action.ecs_scheduled_action.arn
}
