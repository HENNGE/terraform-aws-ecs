variable "ecs_cluster_name" {
  description = "ECS Cluster name to apply on (NOT ARN)"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS Service name to apply on (NOT ARN)"
  type        = string
}

variable "min_capacity" {
  description = "Minimum capacity of ECS autoscaling target, cannot be more than max_capacity"
  type        = number
}

variable "max_capacity" {
  description = "Maximum capacity of ECS autoscaling target, cannot be less than min_capacity"
  type        = number
}

variable "ignore_capacity_changes" {
  description = "Ignores any changes to `min_capacity` and `max_capacity` parameter after apply. Note updating this value will destroy the existing autoscaling target and recreate it."
  default     = false
  type        = bool
}

variable "role_arn" {
  description = "ARN of the IAM role that allows Application AutoScaling to modify your scalable target on your behalf. This defaults to an IAM Service-Linked Role for most services and custom IAM Roles are ignored by the API for those namespaces."
  default     = null
  type        = string
}

variable "suspended_state" {
  description = "Specifies whether the scaling activities for a scalable target are in a suspended state."
  default     = null
  type = object({
    dynamic_scaling_in_suspended  = bool
    dynamic_scaling_out_suspended = bool
    scheduled_scaling_suspended   = bool
  })
}
