####################
# Required variables
####################

variable "name" {
  description = "The service name."
  type        = string
}

variable "cluster" {
  description = "The cluster name or ARN."
  type        = string
}

variable "container_definitions" {
  description = "Container definitions raw json string or rendered template. Not required if `create_task_definition` is `false`."
  default     = null
  type        = string
}

variable "create_task_definition" {
  description = "Create the task definition"
  default     = true
  type        = bool
}

variable "task_definition_arn" {
  description = "If `create_task_definition` is `false`, provide the ARN of task definition to use"
  default     = null
  type        = string
}

#########
# Options
#########

#############
# IAM Section
#############

variable "iam_lb_role" {
  description = "IAM Role ARN to use to attach service to Load Balancer. This parameter is required if you are using a load balancer with your service, but only if your task definition does not use the awsvpc network mode. If using awsvpc network mode, do not specify this role. If your account has already created the Amazon ECS service-linked role, that role is used by default for your service unless you specify a role here."
  default     = null
  type        = string
}

variable "iam_task_role" {
  description = "IAM Role for task to use to access AWS services (dynamo, s3, etc.)"
  default     = null
  type        = string
}

variable "iam_daemon_role" {
  description = "IAM Role for ECS Agent and Docker Daemon to use (ECR, etc.). Required if specifying `repositoryCredentials` in container configuration."
  default     = null
  type        = string
}

#################
# Service Section
#################

variable "desired_count" {
  description = "The number of instances of the task definition to place and keep running. Defaults to 0. Do not specify if using the `DAEMON` scheduling strategy."
  default     = null
  type        = number
}

variable "ignore_desired_count_changes" {
  description = "Ignores any changes to `desired_count` parameter after apply. Note updating this value will destroy the existing service and recreate it."
  default     = false
  type        = bool
}

variable "deployment_controller" {
  description = "Type of deployment controller. Valid values: `CODE_DEPLOY`, `ECS`."
  default     = "ECS"
  type        = string
}

variable "deployment_minimum_healthy_percent" {
  description = "lower limit (% of `desired_count`) of # of running tasks during a deployment"
  default     = 100
  type        = number
}

variable "deployment_maximum_percent" {
  description = "upper limit (% of `desired_count`) of # of running tasks during a deployment. Do not fill when using `DAEMON` scheduling strategy."
  default     = null
  type        = number
}

variable "enable_ecs_managed_tags" {
  description = "Specifies whether to enable Amazon ECS managed tags for the tasks within the service. Boolean value."
  default     = null
  type        = bool
}

variable "enable_execute_command" {
  description = "Specifies whether to enable Amazon ECS Exec for the tasks within the service."
  default     = null
  type        = bool
}

variable "enable_deployment_circuit_breaker_without_rollback" {
  description = "Enable Deployment Circuit Breaker without Rollback."
  default     = false
  type        = bool
}
variable "enable_deployment_circuit_breaker_with_rollback" {
  description = "Enable Deployment Circuit Breaker with Rollback. When a service deployment fails, the service is rolled back to the last deployment that completed successfully."
  default     = false
  type        = bool
}

variable "force_new_deployment" {
  description = "Enable to force a new task deployment of the service. This can be used to update tasks to use a newer Docker image with same image/tag combination (e.g. `myimage:latest`), roll Fargate tasks onto a newer platform version, or immediately deploy `ordered_placement_strategy` and `placement_constraints` updates."
  default     = null
  type        = bool
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers."
  default     = null
  type        = number
}

variable "launch_type" {
  description = "The launch type on which to run your service. The valid values are `EC2` or `FARGATE`."
  default     = null
  type        = string
}

variable "platform_version" {
  description = "The platform version on which to run your service. Only applicable for `launch_type` set to `FARGATE`. Defaults to `LATEST`. [AWS Docs](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/platform_versions.html)"
  default     = null
  type        = string
}

variable "propagate_tags" {
  description = "Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are `SERVICE` and `TASK_DEFINITION`."
  default     = null
  type        = string
}

variable "scheduling_strategy" {
  description = "The scheduling strategy to use for the service. The valid values are `REPLICA` and `DAEMON`. Fargate Tasks do not support `DAEMON` scheduling strategy."
  default     = null
  type        = string
}

variable "wait_for_steady_state" {
  description = "If `true`, Terraform will wait for the service to reach a steady state (like aws ecs wait services-stable) before continuing."
  default     = null
  type        = bool
}

variable "load_balancers" {
  description = "List of map for load balancers configuration."
  default     = []
  type        = list(any)
}

variable "network_configuration" {
  description = "Map of a network configuration for the service. This parameter is required for task definitions that use the awsvpc network mode to receive their own Elastic Network Interface, and it is not supported for other network modes. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#network_configuration)"
  default     = null
  type        = any
}

variable "service_registry" {
  description = "Map of a service discovery registries for the service. Consists of `registry_arn`, `port`(optional), `container_port`(optional), `container_port`(optional). [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#service_registries)"
  default     = null
  type        = any
}

variable "capacity_provider_strategy" {
  description = "List of map of the capacity provider strategy to use for the service. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#capacity_provider_strategy)"
  default     = []
  type        = list(any)
}

variable "ordered_placement_strategy" {
  description = "List of map of service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence. Max 5. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#ordered_placement_strategy)"
  default     = []
  type        = list(any)
}

variable "service_placement_constraints" {
  description = "List of map of placement constraints for Service. Max 10. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#placement_constraints)"
  default     = []
  type        = list(any)
}

variable "task_placement_constraints" {
  description = "Placement constraints for Task Definition. List of map. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#placement_constraints)"
  default     = []
  type        = list(any)
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  default     = {}
  type        = map(string)
}

##########################################################################
# Task Definition section
# This section is entirely optional if `create_task_definition` is `false`
##########################################################################

variable "task_cpu" {
  description = "Task level CPU units."
  default     = null
  type        = number
}

variable "task_memory" {
  description = "Task level Memory units."
  default     = null
  type        = number
}

variable "task_network_mode" {
  description = "The network mode for container."
  default     = "bridge"
  type        = string
}

variable "task_ipc_mode" {
  description = "The IPC resource namespace to be used for the containers in the task The valid values are `host`, `task`, and `none`."
  default     = null
  type        = string
}

variable "task_pid_mode" {
  description = "The process namespace to use for the containers in the task. The valid values are `host` and `task`."
  default     = null
  type        = string
}

variable "task_requires_compatibilites" {
  description = "A set of launch types required by the task. The valid values are `EC2` and `FARGATE`."
  default     = ["EC2"]
  type        = list(string)
}

variable "task_volume_configurations" {
  description = "Volume Block Arguments for Task Definition. List of map. Note that `docker_volume_configuration` should be specified as map argument instead of block. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#volume)"
  default     = []
  type        = list(any)
}

variable "task_inference_accelerator" {
  description = "Inference accelerator for Task Definition. List of map. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#inference_accelerator)"
  default     = []
  type        = list(any)
}

variable "task_proxy_configuration" {
  description = "The proxy configuration details for the App Mesh proxy. Defined as map argument. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#proxy_configuration)"
  default     = null
  type        = any
}

variable "task_runtime_platform" {
  description = "Runtime platform (operating system and CPU architecture) that containers may use. Defined as map argument. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#runtime_platform)"
  default     = null
  type        = any
}
