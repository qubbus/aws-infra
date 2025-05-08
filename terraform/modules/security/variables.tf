variable "vpc_id" {
  type = string
}

variable "allowed_cidrs" {
  type = list(string)
}

variable "alb_name" {
  type = string
}

variable "ecs_name" {
  type = string
}
