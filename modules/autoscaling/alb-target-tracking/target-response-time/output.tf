output "arn" {
  description = "ARN of the autoscaling policy generated."
  value       = aws_appautoscaling_policy.ecs_policy.arn
}

output "name" {
  description = "Name of the autoscaling policy generated"
  value       = aws_appautoscaling_policy.ecs_policy.name
}

output "policy_type" {
  description = "Policy type of the autoscaling policy generated. Always TargetTrackingScaling"
  value       = aws_appautoscaling_policy.ecs_policy.policy_type
}
