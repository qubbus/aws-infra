variable "cluster_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "container_image" {
  type = string
}

variable "container_port" {
  type = number
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "alb_target_group_arn" {
  type = string
}

variable "ecs_service_sg_id" {
  type = string
}

variable "db_host" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_password_ssm_arn" {
  type = string
}
