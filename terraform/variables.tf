variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "app_name" {
  description = "Application name prefix used for resource naming"
  type        = string
  default     = "api-app"
}

variable "domain_name" {
  description = "Domain name for HTTPS certificate"
  type        = string
  default     = "api.example.com"
}

variable "container_image" {
  description = "Docker image for the application"
  type        = string
  default     = "nginx:latest" # Replace with your actual application image
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 8080 # As per requirements
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "PostgreSQL database username"
  type        = string
  default     = "appuser"
}