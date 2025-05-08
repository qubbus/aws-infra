output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.alb.alb_dns_name
}

output "db_host" {
  description = "RDS database hostname"
  value       = module.rds.db_host
}

output "db_password_ssm_arn" {
  description = "ARN of the SSM parameter storing the database password"
  value       = module.rds.db_password_ssm_arn
}