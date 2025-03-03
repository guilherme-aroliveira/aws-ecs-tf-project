variable "environment" {
  description = "The environment name of the application"
  default = ""
}

variable "ecs_cluster_name" {
  description = "The name of ECS cluster"
}

variable "ecs_service_name" {
  description = "The name of the ECS service"
}

variable "docker_container_port" {
  description = "value"
  type = string
  default = "value"
}

variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "vpc_cidr" {
  description = "The VPC cidr block"
}

variable "public_subnets" {
  description = "Public subnet IDs"
}

variable "ecs_acm_cert_arn" {
  description = "value"
}

variable "domain_name" {
  description = "value"
  default = ""
}