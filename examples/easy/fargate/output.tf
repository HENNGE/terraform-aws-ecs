output "ecs_cluster_name" {
  description = "Name of the ECS Cluster created"
  value       = module.ecs_cluster.name
}

output "ecs_service_name" {
  description = "Name of the ECS Service created"
  value       = module.easy_fargate.name
}
