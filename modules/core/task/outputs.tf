output "arn" {
  description = "Full ARN of the Task Definition (including both `family` and `revision`)."
  value       = var.create_task_definition ? concat(aws_ecs_task_definition.main[*].arn, [""])[0] : ""
}

output "name" {
  description = "The created task definition name"
  value       = var.create_task_definition ? concat(aws_ecs_task_definition.main[*].family, [""])[0] : ""
}

output "revision" {
  description = "The revision number of the task definition"
  value       = var.create_task_definition ? concat(aws_ecs_task_definition.main[*].revision, [""])[0] : ""
}
