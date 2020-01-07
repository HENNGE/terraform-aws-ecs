output "cpu_autoscaling_arn" {
  description = "The ARN assigned by AWS to the scaling policy."
  value       = join("", aws_autoscaling_policy.cpu_autoscaling.*.arn)
}

output "cpu_autoscaling_name" {
  description = "The scaling policy's name."
  value       = join("", aws_autoscaling_policy.cpu_autoscaling.*.name)
}

output "cpu_autoscaling_asg_name" {
  description = "The scaling policy's assigned autoscaling group."
  value       = join("", aws_autoscaling_policy.cpu_autoscaling.*.autoscaling_group_name)
}

output "cpu_autoscaling_policy_type" {
  description = "The scaling policy's type."
  value       = join("", aws_autoscaling_policy.cpu_autoscaling.*.policy_type)
}

output "memory_autoscaling_arn" {
  description = "The ARN assigned by AWS to the scaling policy."
  value       = join("", aws_autoscaling_policy.memory_autoscaling.*.arn)
}

output "memory_autoscaling_name" {
  description = "The scaling policy's name."
  value       = join("", aws_autoscaling_policy.memory_autoscaling.*.name)
}

output "memory_autoscaling_asg_name" {
  description = "The scaling policy's assigned autoscaling group."
  value       = join("", aws_autoscaling_policy.memory_autoscaling.*.autoscaling_group_name)
}

output "memory_autoscaling_policy_type" {
  description = "The scaling policy's type."
  value       = join("", aws_autoscaling_policy.memory_autoscaling.*.policy_type)
}
