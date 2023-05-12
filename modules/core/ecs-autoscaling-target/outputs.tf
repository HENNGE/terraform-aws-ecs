locals {
  output_resource_id        = concat(aws_appautoscaling_target.ecs_target[*].resource_id, aws_appautoscaling_target.ecs_target_ignore_capacity_changes[*].resource_id, [""])[0]
  output_service_namespace  = concat(aws_appautoscaling_target.ecs_target[*].service_namespace, aws_appautoscaling_target.ecs_target_ignore_capacity_changes[*].service_namespace, [""])[0]
  output_scalable_dimension = concat(aws_appautoscaling_target.ecs_target[*].scalable_dimension, aws_appautoscaling_target.ecs_target_ignore_capacity_changes[*].scalable_dimension, [""])[0]
  output_min_capacity       = concat(aws_appautoscaling_target.ecs_target[*].min_capacity, aws_appautoscaling_target.ecs_target_ignore_capacity_changes[*].min_capacity, [""])[0]
  output_max_capacity       = concat(aws_appautoscaling_target.ecs_target[*].max_capacity, aws_appautoscaling_target.ecs_target_ignore_capacity_changes[*].max_capacity, [""])[0]
}

output "resource_id" {
  description = "Resources ID of the created Autoscaling Target for ECS Service, used in policy/schedule"
  value       = local.output_resource_id
}

output "service_namespace" {
  description = "Service namespace for autoscaling target. Always ecs"
  value       = local.output_service_namespace
}

output "scalable_dimension" {
  description = "Scalable dimension for autoscaling target. Always ecs:service:DesiredCount."
  value       = local.output_scalable_dimension
}

output "min_capacity" {
  description = "Minimum capacity for autoscaling target, same value as inputted"
  value       = local.output_min_capacity
}

output "max_capacity" {
  description = "Maximum capacity for autoscaling target, same value as inputted"
  value       = local.output_max_capacity
}
