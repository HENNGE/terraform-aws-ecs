output "cpu_policy_arn" {
  description = "ARN of the autoscaling policy generated."
  value       = concat(aws_appautoscaling_policy.ecs_service_cpu_policy[*].arn, [""])
}

output "cpu_policy_name" {
  description = "Name of the autoscaling policy generated"
  value       = concat(aws_appautoscaling_policy.ecs_service_cpu_policy[*].name, [""])
}

output "cpu_policy_type" {
  description = "Policy type of the autoscaling policy generated. Always TargetTrackingScaling"
  value       = concat(aws_appautoscaling_policy.ecs_service_cpu_policy[*].policy_type, [""])
}

output "memory_policy_arn" {
  description = "ARN of the autoscaling policy generated."
  value       = concat(aws_appautoscaling_policy.ecs_service_memory_policy[*].arn, [""])
}

output "memory_policy_name" {
  description = "Name of the autoscaling policy generated"
  value       = concat(aws_appautoscaling_policy.ecs_service_memory_policy[*].name, [""])
}

output "memory_policy_type" {
  description = "Policy type of the autoscaling policy generated. Always TargetTrackingScaling"
  value       = concat(aws_appautoscaling_policy.ecs_service_memory_policy[*].policy_type, [""])
}
