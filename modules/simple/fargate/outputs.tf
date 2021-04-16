output "id" {
  description = "The Amazon Resource Name (ARN) that identifies the service"
  value       = module.fargate.id
}

output "name" {
  description = "The name of the service"
  value       = module.fargate.name
}

output "cluster" {
  description = "The Amazon Resource Name (ARN) of cluster which the service runs on"
  value       = module.fargate.cluster
}

output "desired_count" {
  description = "The number of instances of the task definition"
  value       = module.fargate.desired_count
}

output "task_definition_arn" {
  description = "The complete ARN of task definition generated includes Task Family and Task Revision"
  value       = module.fargate.task_definition_arn
}

output "task_definition_name" {
  description = "The name (family) of created Task Definition."
  value       = module.fargate.task_definition_name
}

output "task_definition_revision" {
  description = "The revision of the task in a particular family"
  value       = module.fargate.task_definition_revision
}
