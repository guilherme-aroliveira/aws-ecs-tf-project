variable "environment" {
  description = "The environment name of the application"
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

variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "vpc_cidr" {
  description = "The VPC cidr block"
}

variable "public_subnets" {
  description = "Public subnet IDs"
}

variable "ecs_acm_cert_resource" {
  description = "The acm certificate resource"
}

variable "ecs_acm_cert_arn" {
  description = "The certificate arn"
}

variable "domain_name" {
  description = "The Route53 domain"
  default     = "guilhermeoliveira.ch"
}
