variable "name" {
  description = "Name for scheduled action"
  type        = string
}

variable "schedule_description" {
  description = "The description of the rule"
  default     = "Cloudwatch event rule to invoke ECS Task"
  type        = string
}

variable "schedule_rule" {
  description = "Schedule in cron or rate (see: https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html for rules)"
  type        = string
}

variable "iam_invoker" {
  description = "IAM ARN to invoke ECS Task"
  type        = string
}

variable "cluster_arn" {
  description = "ECS Cluster ARN to run ECS Task in"
  type        = string
}

variable "task_count" {
  description = "Desired ECS Task count to run"
  type        = number
}

variable "task_definition_arn" {
  description = "Task definition ARN to run"
  type        = string
}

variable "is_fargate" {
  description = "Task is fargate"
  default     = false
  type        = bool
}

variable "fargate_assign_public_ip" {
  description = "Assign Public IP or not to Fargate task, specify if `is_fargate`"
  default     = false
  type        = bool
}

variable "fargate_security_groups" {
  description = "Security groups to assign to Fargate task, specify if `is_fargate`"
  default     = []
  type        = list(string)
}

variable "fargate_subnets" {
  description = "Subnets to assign to Fargate task, specify if `is_fargate`"
  default     = []
  type        = list(string)
}

variable "container_overrides" {
  description = "Overrides options of container. Expecting JSON. See https://www.terraform.io/docs/providers/aws/r/cloudwatch_event_target.html#example-ecs-run-task-with-role-and-task-override-usage"
  default     = null
  type        = string
}
