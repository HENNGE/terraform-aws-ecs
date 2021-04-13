output "arn" {
  description = "ARN of the generated cluster"
  value       = aws_ecs_cluster.main.arn
}

output "name" {
  description = "Name of the Cluster"
  value       = var.name
}
