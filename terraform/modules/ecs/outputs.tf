output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = "springboot-cluster"
}

output "ecs_cluster_id" {
  description = "The ID of the ECS cluster"
  value = aws_ecs_cluster.ecs_cluster.id
}
