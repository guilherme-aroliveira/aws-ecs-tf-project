variable "environment" {
  description = "The environment name the application"
  default     = ""
}

variable "ecs_cluster_name" {
  description = "The name of the ECS Cluster"
  type        = string
  default     = "springboot-cluster"
}

variable "ecs_service_name" {
  description = "The name of the ECS service"
  type        = string
  default     = "springbootapp"
}

variable "task_definition_name" {
  description = "value"
  type        = string
  default     = "springboot-task"
}

variable "task_numbers" {
  description = "The"
  type        = string
  default     = "2"
}

variable "spring_profile" {
  description = "value"
  type        = string
  default     = "default"
}

variable "region" {
  description = "value"
  type        = string
  default     = "us-east-1"
}

###### Values from outputs ######

variable "ecr_uri" {
  description = "The environment name the application"
}

variable "ecs_cloudwatch_log" {
  description = "The name of the cloudwatch log group"
}

variable "ecs_app_sg" {
  description = "The ID of the application security group"
}

variable "public_subnets" {
  description = "The ID of the public subnets"
}

variable "fargate_role" {
  description = "value"
}

variable "ecs_app_tg" {
  description = "value"
}
