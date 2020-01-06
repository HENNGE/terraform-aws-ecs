locals {
  this_task_definition_arn      = var.create_task_definition ? module.task.arn : var.task_definition_arn
  this_task_definition_name     = var.create_task_definition ? module.task.name : ""
  this_task_definition_revision = var.create_task_definition ? module.task.revision : ""

  this_service_id            = concat(aws_ecs_service.main[*].id, aws_ecs_service.main_ignore_desired_count_changes[*].id, [""])[0]
  this_service_name          = concat(aws_ecs_service.main[*].name, aws_ecs_service.main_ignore_desired_count_changes[*].name, [""])[0]
  this_service_cluster_name  = concat(aws_ecs_service.main[*].cluster, aws_ecs_service.main_ignore_desired_count_changes[*].cluster, [""])[0]
  this_service_iam_role      = concat(aws_ecs_service.main[*].iam_role, aws_ecs_service.main_ignore_desired_count_changes[*].iam_role, [""])[0]
  this_service_desired_count = concat(aws_ecs_service.main[*].desired_count, aws_ecs_service.main_ignore_desired_count_changes[*].desired_count, [""])[0]
}

output "id" {
  description = "The Amazon Resource Name (ARN) that identifies the service"
  value       = local.this_service_id
}

output "name" {
  description = "The name of the service"
  value       = local.this_service_name
}

output "cluster" {
  description = "The Amazon Resource Name (ARN) of cluster which the service runs on"
  value       = local.this_service_cluster_name
}

output "desired_count" {
  description = "The number of instances of the task definition"
  value       = local.this_service_desired_count
}

output "task_definition_arn" {
  description = "The complete ARN of task definition generated includes Task Family and Task Revision"
  value       = local.this_task_definition_arn
}

output "task_definition_name" {
  description = "The name (family) of created Task Definition."
  value       = local.this_task_definition_name
}

output "task_definition_revision" {
  description = "The revision of the task in a particular family"
  value       = local.this_task_definition_revision
}
