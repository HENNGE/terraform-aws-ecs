/**
 * Required Variables.
 */

variable "name" {
  description = "The task name."
  type        = string
}

variable "container_definitions" {
  description = "Container definitions raw json string or rendered template."
  type        = string
}

/**
 * Optional Variables.
 */

variable "create_task_definition" {
  description = "Create the Task Definition"
  default     = true
  type        = bool
}

variable "network_mode" {
  description = "The network mode for container."
  default     = "bridge"
  type        = string
}

variable "ipc_mode" {
  description = "The IPC resource namespace to be used for the containers in the task The valid values are `host`, `task`, and `none`."
  default     = null
  type        = string
}

variable "pid_mode" {
  description = "The process namespace to use for the containers in the task. The valid values are `host` and `task`."
  default     = null
  type        = string
}

variable "task_role" {
  description = "The IAM Role to assign to the Container."
  default     = null
  type        = string
}

variable "daemon_role" {
  description = "The IAM Role to assign for the ECS container agent and Docker daemon."
  default     = null
  type        = string
}

variable "cpu" {
  description = "CPU unit for this task."
  default     = null
  type        = number
}

variable "memory" {
  description = "Memory for this task."
  default     = null
  type        = number
}

variable "requires_compatibilites" {
  description = "A set of launch types required by the task. The valid values are EC2 and FARGATE."
  default     = ["EC2"]
  type        = list(string)
}

variable "volume_configurations" {
  description = "Volume Block Arguments for Task Definition. List of map. Note that `docker_volume_configuration` should be specified as map argument instead of block. [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html#volume-block-arguments)"
  default     = []
  type        = list(any)
}

variable "placement_constraints" {
  description = "Placement constraints for Task Definition. List of map. [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html#placement_constraints)"
  default     = []
  type        = list(any)
}

variable "proxy_configuration" {
  description = "The proxy configuration details for the App Mesh proxy. Defined as map argument. [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html#proxy-configuration-arguments)"
  default     = null
  type        = any
}

variable "tags" {
  description = "Key-value mapping of resource tags."
  default     = {}
  type        = map(string)
}
