variable "domain_name" {
  description = "value"
  default = "guilhermeoliveira.ch"
}

variable "ecs_acm_cert" {
  description = "The ECS domain certification"
}

variable "ecs_lb" {
  description = "The ECS cluster load balancer"
}