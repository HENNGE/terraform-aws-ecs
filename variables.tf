variable "name" {
  description = "Cluster name."
  type        = string
}

variable "capacity_providers" {
  description = "List of short names or full Amazon Resource Names (ARNs) of one or more capacity providers to associate with the cluster. Valid values also include `FARGATE` and `FARGATE_SPOT`."
  default     = null
  type        = list(string)
}

variable "default_capacity_provider_strategy" {
  description = "The capacity provider strategy to use by default for the cluster. Can be one or more. List of map with corresponding items in docs. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster#default_capacity_provider_strategy)"
  default     = []
  type        = list(any)
}

variable "settings" {
  description = "List of maps with cluster settings. For example, this can be used to enable CloudWatch Container Insights for a cluster. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster#setting)"
  default     = []
  type        = list(any)
}

variable "enable_container_insights" {
  description = "Enable container insights."
  default     = false
  type        = bool
}

variable "container_insights_enhanced" {
  description = "Use container insights with enhanced observability."
  default     = false
  type        = bool
}

variable "execute_command_configuration" {
  description = "Map with execute command configuration. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster#execute_command_configuration)"
  default     = null
  type        = any
}

variable "tags" {
  description = "Key-value mapping of resource tags."
  default     = {}
  type        = map(string)
}
