variable "instance_profile_arn" {
  description = "Instance Profile to use for EC2 to join to ECS Cluster. See `modules/iam/ecs-instance-profile`"
  type        = string
}

variable "availability_zones" {
  description = "Override automatic detection of availability zones"
  default     = []
  type        = list(string)
}

variable "enable_ipv6" {
  description = "Enable IPv6?"
  default     = true
  type        = bool
}
