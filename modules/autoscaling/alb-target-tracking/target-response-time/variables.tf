variable "name" {
  description = "Name of the ECS Policy created, will appear in Auto Scaling under Service in ECS"
  type        = string
}

variable "alb_arn_suffix" {
  description = "ARN Suffix (not full ARN) of the Application Load Balancer for use with CloudWatch. Output attribute from LB resource: `arn_suffix`"
  type        = string
}

variable "target_group_arn_suffix" {
  description = "ALB Target Group ARN Suffix (not full ARN) for use with CloudWatch. Output attribute from Target Group resource: `arn_suffix`"
  type        = string
}

variable "scalable_target_resource_id" {
  description = "Scalable target resource id, either from resource `aws_appautoscaling_target` or from `core/ecs-autoscaling-target` module"
  type        = string
}

variable "target_value" {
  description = "Response time per target in target group metrics to trigger scaling activity (in seconds)"
  type        = number
}

variable "scale_in_cooldown" {
  description = "Time between scale in action"
  default     = 300
  type        = number
}

variable "scale_out_cooldown" {
  description = "Time between scale out action"
  default     = 300
  type        = number
}

variable "disable_scale_in" {
  description = "Disable scale-in action, defaults to false"
  default     = false
  type        = bool
}

variable "statistic" {
  description = "Statistic to use. Valid value one of [Average, Minimum, Maximum, SampleCount, Sum]"
  default     = "Average"
  type        = string
}

variable "units" {
  description = "Units to use in monitoring, valid values are [Seconds, Microseconds, Milliseconds]"
  default     = "Seconds"
  type        = string
}
