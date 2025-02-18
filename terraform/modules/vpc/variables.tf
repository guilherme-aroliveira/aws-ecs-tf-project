variable "environment" {
  description = "Enviroment for each project (dev, stg, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "VPC cidr block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "The public subnets for the VPC"
  type        = map(number)
  default = {
    "public_subnet_1" = 1
    "public_subnet_2" = 2
    "public_subnet_3" = 3
  }
}

variable "private_subnets" {
  description = "The private subnets for the VPC"
  type        = map(number)
  default = {
    "private_subnet_1" = 1
    "private_subnet_2" = 2
    "private_subnet_3" = 3
  }
}
