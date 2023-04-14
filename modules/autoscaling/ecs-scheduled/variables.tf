variable "name" {
  description = "Name of the autoscaling scheduled action, will appear in Auto Scaling under Service in ECS"
  type        = string
}

variable "scalable_target_resource_id" {
  description = "Scalable target resource id, either from resource `aws_appautoscaling_target` or from `core/ecs-autoscaling-target` module"
  type        = string
}

variable "schedule" {
  description = "Schedule expression. See https://docs.aws.amazon.com/autoscaling/application/APIReference/API_PutScheduledAction.html#autoscaling-PutScheduledAction-request-Schedule"
  type        = string
}

variable "timezone" {
  description = "Time zone used when setting a scheduled action by using an at or cron expression. For valid values see https://www.joda.org/joda-time/timezones.html"
  type        = string
  default     = null
}

variable "min_capacity" {
  description = "Minimum capacity. At least one of max_capacity or min_capacity must be set."
  type        = string
  default     = null
}

variable "max_capacity" {
  description = "Maximum capacity. At least one of max_capacity or min_capacity must be set."
  type        = string
  default     = null
}
