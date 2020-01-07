output "resource_id" {
  description = "Resources ID of the created Autoscaling Target for ECS Service, used in policy/schedule"
  value       = aws_appautoscaling_target.ecs_target.resource_id
}

output "service_namespace" {
  description = "Service namespace for autoscaling target. Always ecs"
  value       = aws_appautoscaling_target.ecs_target.service_namespace
}

output "scalable_dimension" {
  description = "Scalable dimension for autoscaling target. Always ecs:service:DesiredCount."
  value       = aws_appautoscaling_target.ecs_target.scalable_dimension
}

output "min_capacity" {
  description = "Minimum capacity for autoscaling target, same value as inputted"
  value       = aws_appautoscaling_target.ecs_target.min_capacity
}

output "max_capacity" {
  description = "Maximum capacity for autoscaling target, same value as inputted"
  value       = aws_appautoscaling_target.ecs_target.max_capacity
}
