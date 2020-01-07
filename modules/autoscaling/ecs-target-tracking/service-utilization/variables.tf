variable "name" {
  description = "Name of the ECS Policy created, will appear in Auto Scaling under Service in ECS"
  type        = string
}

variable "scalable_target_resource_id" {
  description = "Scalable target resource id, either from resource `aws_appautoscaling_target` or from `core/ecs-autoscaling-target` module"
  type        = string
}

variable "target_cpu_value" {
  description = "Autoscale when CPU Usage value over the specified value. Must be specified if `enable_cpu_based_autoscaling` is `true`."
  default     = null
  type        = number
}

variable "target_memory_value" {
  description = "Autoscale when Memory Usage value over the specified value. Must be specified if `enable_memory_based_autoscaling` is `true`."
  default     = null
  type        = number
}

variable "enable_cpu_based_autoscaling" {
  description = "Enable Autoscaling based on ECS Service CPU Usage"
  default     = false
  type        = bool
}

variable "enable_memory_based_autoscaling" {
  description = "Enable Autoscaling based on ECS Service Memory Usage"
  default     = false
  type        = bool
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