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
