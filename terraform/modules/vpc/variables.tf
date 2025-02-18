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
    "public-subnet-1" = 1
    "public-subnet-2" = 2
    "public-subnet-3" = 3
  }
}

variable "private_subnets" {
  description = "The private subnets for the VPC"
  type        = map(number)
  default = {
    "private-subnet-1" = 1
    "private-subnet-2" = 2
    "private-subnet-3" = 3
  }
}
