resource "random_password" "db" {
  length  = 16
  special = true
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "this" {
  identifier             = "${var.name_prefix}-postgres"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = var.db_name
  username               = var.db_username
  password               = random_password.db.result
  skip_final_snapshot    = true
  vpc_security_group_ids = var.rds_sg_ids
  db_subnet_group_name   = aws_db_subnet_group.this.name
  publicly_accessible    = false
}

resource "aws_ssm_parameter" "password" {
  name  = var.secret_name
  type  = "SecureString"
  value = random_password.db.result
}
