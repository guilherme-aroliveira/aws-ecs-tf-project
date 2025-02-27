variable "environment" {
  description = "The environment name of the application"
  default = ""
}

variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "public_subnet_1" {
  description = "The ID of the public subnet 1"
}

variable "public_subnet_2" {
  description = "The ID of the public subnet 2"
}

variable "public_subnet_3" {
  description = "The ID of the public subnet 3"
}

variable "ecs_cluster_name" {
  description = "The name of ECS cluster"
}