resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

module "security" {
  source = "./modules/security"

  vpc_id        = data.aws_vpc.existing.id
  allowed_cidrs = ["75.2.60.0/24"]
  alb_name      = var.app_name
  ecs_name      = var.app_name
}

module "rds" {
  source = "./modules/rds"

  name_prefix = var.app_name
  db_name     = var.db_name
  db_username = var.db_username
  vpc_id      = data.aws_vpc.existing.id
  subnet_ids  = data.aws_subnets.private.ids
  rds_sg_ids  = [module.security.rds_sg_id]
  secret_name = "/${var.app_name}/db/password"
}

module "alb" {
  source = "./modules/alb"

  alb_name        = var.app_name
  vpc_id          = data.aws_vpc.existing.id
  public_subnets  = data.aws_subnets.public.ids
  alb_sg_id       = module.security.alb_sg_id
  certificate_arn = aws_acm_certificate.this.arn
  container_port  = var.container_port
}

module "ecs" {
  source = "./modules/ecs"

  cluster_name         = "${var.app_name}-cluster"
  service_name         = var.app_name
  container_image      = var.container_image
  container_port       = var.container_port
  vpc_id               = data.aws_vpc.existing.id
  subnet_ids           = data.aws_subnets.private.ids
  alb_target_group_arn = module.alb.target_group_arn
  ecs_service_sg_id    = module.security.ecs_service_sg_id
  db_host              = module.rds.db_host
  db_user              = var.db_username
  db_password_ssm_arn  = module.rds.db_password_ssm_arn
}
