variable "ecs_cluster_name" {
  description = "The name of the ECS Cluster"
  type        = string
  default     = "springboot-cluster"
}

variable "ecs_service_name" {
  description = "The name of the ECS service"
  type = string
  default = "springbootapp"
}