variable "environment" {
  description = "The environment name the application"
  default = ""
}

variable "ecs_cluster_name" {
  description = "The name of the ECS Cluster"
  type        = string
  default     = "springboot-cluster"
}

variable "ecs_cloudwatch_log" {
  description = "The name of the cloudwatch log group"
}