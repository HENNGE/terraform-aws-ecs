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
  type        = string
}

variable "cpu" {
  description = "CPU unit for this task"
  type        = number
}

variable "memory" {
  description = "Memory for this task"
  type        = number
}

variable "vpc_subnets" {
  description = "VPC Subnets where the tasks should live in"
  type        = list(string)
}

variable "security_groups" {
  description = "Security Groups to apply for the task"
  type        = list(string)
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

###################
# Optional settings
###################

variable "alarms" {
  description = "List of CloudWatch alarms to monitor for the service. If any alarm is in ALARM state, the service will be marked as unhealthy and will be stopped."
  default     = null
  type = object({
    alarm_names = list(string)
    enable      = bool
    rollback    = bool
  })
}

variable "availability_zone_rebalancing" {
  description = "If `ENABLED`, ECS will rebalance tasks across Availability Zones in the cluster when a new task is launched. This is only applicable to services that use the `REPLICA` scheduling strategy."
  default     = "DISABLED"
  type        = string
}

variable "desired_count" {
  description = "The number of instances of the task definition to place and keep running. Defaults to 0. Do not specify if using the `DAEMON` scheduling strategy."
  default     = null
  type        = number
}

variable "enable_fault_injection" {
  description = "Enables fault injection and allows for fault injection requests to be accepted from the task's containers."
  default     = false
  type        = bool
}

variable "ephemeral_storage" {
  description = "The amount of ephemeral storage to allocate for the task. This parameter is used to expand the total amount of ephemeral storage available, beyond the default amount, for tasks hosted on AWS Fargate."
  default     = null
  type = object({
    size_in_gib = number
  })
}

variable "placement_constraints" {
  description = "Placement constraints for Task Definition. List of map. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#placement_constraints)"
  default     = []
  type = list(object({
    expression = optional(string)
    type       = string
  }))
}

variable "force_delete" {
  description = "Enable to delete a service even if it wasn't scaled down to zero tasks. It's only necessary to use this if the service uses the REPLICA scheduling strategy."
  default     = false
  type        = bool
}

variable "num_of_task_on_demand" {
  description = "The number of task to run on FARGATE on-demand that must run all the time. Note: Changing this number after creation will destroy and recreate the service (downtime)."
  default     = 0
  type        = number
}

variable "ignore_desired_count_changes" {
  description = "Ignores any changes to `desired_count` parameter after apply. Note updating this value will destroy the existing service and recreate it."
  default     = false
  type        = bool
}

variable "assign_public_ip" {
  description = "Assign public IP to the ENI"
  default     = false
  type        = bool
}

variable "elb_name" {
  description = "Name of ELB (Classic ELB) to associate with the service"
  default     = null
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the Application Load Balancer / Network Load Balancer target group"
  default     = null
  type        = string
}

variable "container_name" {
  description = "Container name to register to Load Balancer"
  default     = null
  type        = string
}

variable "container_port" {
  description = "The container port, must match the container exposed port"
  default     = null
  type        = string
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers."
  default     = null
  type        = number
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

variable "platform_version" {
  description = "The platform version on which to run your service. Defaults to `LATEST`. [AWS Docs](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/platform_versions.html)"
  default     = null
  type        = string
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

variable "service_registry" {
  description = "Map of a service discovery registries for the service. Consists of `registry_arn`, `port`(optional), `container_port`(optional), `container_port`(optional). [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#service_registries)"
  default     = null
  type        = any
}

variable "service_connect_configuration" {
  description = "The ECS Service Connect configuration for this service to discover and connect to services, and be discovered by, and connected from, other services within a namespace"
  type = object({
    enabled = bool
    log_configuration = optional(object({
      log_driver = string
      options    = optional(map(string))
      secret_option = optional(object({
        name       = string
        value_from = string
      }))
    }))
    namespace = optional(string)
    service = optional(object({
      client_alias = optional(list(object({
        dns_name = optional(string)
        port     = number
      })), [])
      discovery_name        = optional(string)
      ingress_port_override = optional(number)
      port_name             = string
      timeout = optional(object({
        idle_timeout_seconds        = optional(number)
        per_request_timeout_seconds = optional(number)
      }))
      tls = optional(object({
        issuer_cert_authority = object({
          aws_pca_authority_arn = optional(string)
        })
        kms_key  = optional(string)
        role_arn = optional(string)
      }))
    }))
  })
  default = null
}

variable "skip_destroy" {
  description = "Whether to retain the old revision when the resource is destroyed or replacement is necessary."
  default     = false
  type        = bool
}

variable "track_latest" {
  description = "Whether should track latest ACTIVE task definition on AWS or the one created with the resource stored in state."
  default     = false
  type        = bool
}

variable "service_volume_configurations" {
  description = "List of configurations for a volume specified in the task definition as a volume that is configured at launch time. Currently, the only supported volume type is an Amazon EBS volume."
  default     = []
  type = list(object({
    name = string
    managed_ebs_volume = optional(object({
      role_arn         = string
      encrypted        = optional(bool, true)
      file_system_type = optional(string)
      iops             = optional(number)
      kms_key_id       = optional(string)
      size_in_gb       = optional(number)
      snapshot_id      = optional(string)
      throughput       = optional(number)
      volume_type      = optional(string)
      tag_specifications = optional(list(object({
        resource_type  = string
        propagate_tags = optional(string)
        tags           = optional(map(string))
      })), [])
    }))
  }))
}

variable "task_volume_configurations" {
  description = "Volume Block Arguments for Task Definition. List of map. Note that `docker_volume_configuration` should be specified as map argument instead of block. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#volume)"
  default     = []
  type        = list(any)
}
variable "vpc_lattice_configurations" {
  description = "The VPC Lattice configuration for your service that allows Lattice to connect, secure, and monitor your service across multiple accounts and VPCs"
  default     = []
  type = list(object({
    role_arn         = string
    target_group_arn = string
    port_name        = string
  }))
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

variable "enable_execute_command" {
  description = "Specifies whether to enable Amazon ECS Exec for the tasks within the service."
  default     = null
  type        = bool
}

variable "force_new_deployment" {
  description = "Enable to force a new task deployment of the service. This can be used to update tasks to use a newer Docker image with same image/tag combination (e.g. `myimage:latest`), roll Fargate tasks onto a newer platform version, or immediately deploy `ordered_placement_strategy` and `placement_constraints` updates."
  default     = null
  type        = bool
}

variable "wait_for_steady_state" {
  description = "If `true`, Terraform will wait for the service to reach a steady state (like aws ecs wait services-stable) before continuing."
  default     = null
  type        = bool
}

variable "enable_ecs_managed_tags" {
  description = "Specifies whether to enable Amazon ECS managed tags for the tasks within the service. Boolean value."
  default     = null
  type        = bool
}

variable "propagate_tags" {
  description = "Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are `SERVICE` and `TASK_DEFINITION`."
  default     = null
  type        = string
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  default     = {}
  type        = map(string)
}

variable "ordered_placement_strategy" {
  description = "List of map of service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence. Max 5. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#ordered_placement_strategy)"
  default     = []
  type = list(object({
    type  = string
    field = optional(string)
  }))
}
