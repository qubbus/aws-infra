variable "name_prefix" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "rds_sg_ids" {
  type = list(string)
}

variable "secret_name" {
  type = string
}
