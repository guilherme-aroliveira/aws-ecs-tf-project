output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_service_name" {
  description = "value"
  value = aws_ecs_service.ecs_service.name
}

output "ecs_cluster_id" {
  description = "The ID of the ECS cluster"
  value = aws_ecs_cluster.ecs_cluster.id
}
