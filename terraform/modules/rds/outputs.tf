output "db_host" {
  value = aws_db_instance.this.address
}

output "db_password_ssm_arn" {
  value = aws_ssm_parameter.password.arn
}
