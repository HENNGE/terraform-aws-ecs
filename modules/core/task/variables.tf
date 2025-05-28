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

variable "enable_fault_injection" {
  description = "Enables fault injection and allows for fault injection requests to be accepted from the task's containers."
  default     = false
  type        = bool
}

variable "ephemeral_storage" {
  description = "The amount of ephemeral storage to allocate for the task. This parameter is used to expand the total amount of ephemeral storage available, beyond the default amount, for tasks hosted on AWS Fargate."
  default     = null
  type        = any
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

variable "skip_destroy" {
  description = "Whether to retain the old revision when the resource is destroyed or replacement is necessary."
  default     = false
  type        = bool
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
  description = "Volume Block Arguments for Task Definition. List of map. Note that `docker_volume_configuration` should be specified as map argument instead of block. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#volume)"
  default     = []
  type        = list(any)
}

variable "placement_constraints" {
  description = "Placement constraints for Task Definition. List of map. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#placement_constraints)"
  default     = []
  type        = list(any)
}

variable "inference_accelerator" {
  description = "Inference Accelerators settings. List of map. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#inference_accelerator)"
  default     = []
  type        = list(any)
}

variable "proxy_configuration" {
  description = "The proxy configuration details for the App Mesh proxy. Defined as map argument. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#proxy_configuration)"
  default     = null
  type        = any
}

variable "runtime_platform" {
  description = "Runtime platform (operating system and CPU architecture) that containers may use. Defined as map argument. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#runtime_platform)"
  default     = null
  type        = any
}

variable "track_latest" {
  description = "Whether should track latest ACTIVE task definition on AWS or the one created with the resource stored in state."
  default     = false
  type        = bool
}

variable "tags" {
  description = "Key-value mapping of resource tags."
  default     = {}
  type        = map(string)
}
