variable "name" {
  description = "Name prefix of the Autoscaling Policy"
  type        = string
}

variable "autoscaling_group_name" {
  description = "Autoscaling Group to apply the policy"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name (not ARN) of ECS Cluster that the autoscaling group is attached to"
  type        = string
}

variable "enable_cpu_based_autoscaling" {
  description = "Enable Autoscaling based on ECS Cluster CPU Reservation"
  default     = false
  type        = bool
}

variable "enable_memory_based_autoscaling" {
  description = "Enable Autoscaling based on ECS Cluster Memory Reservation"
  default     = false
  type        = bool
}

variable "cpu_threshold" {
  description = "Keep the ECS Cluster CPU Reservation around this value. Value is in percentage (0..100). Must be specified if cpu based autoscaling is enabled."
  default     = null
  type        = number
}

variable "memory_threshold" {
  description = "Keep the ECS Cluster Memory Reservation around this value. Value is in percentage (0..100). Must be specified if memory based autoscaling is enabled."
  default     = null
  type        = number
}

variable "cpu_statistics" {
  description = "Statistics to use: [Maximum, SampleCount, Sum, Minimum, Average]. Note that resolution used in alarm generated is 1 minute."
  default     = "Average"
  type        = string
}

variable "memory_statistics" {
  description = "Statistics to use: [Maximum, SampleCount, Sum, Minimum, Average]. Note that resolution used in alarm generated is 1 minute."
  default     = "Average"
  type        = string
}

variable "disable_scale_in" {
  description = "Indicates whether scale in by the target tracking policy is disabled."
  default     = false
  type        = bool
}
