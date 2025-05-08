# App Stack: ECS + RDS + HTTPS ALB

## Overview

This Terraform codebase provisions an app stack for running a containerized application in AWS Fargate (ECS), fronted by an HTTPS ALB and backed by a PostgreSQL RDS instance.

## Architecture

- **ALB (HTTPS)** – Exposes app securely over port 443, whitelisting `75.2.60.0/24` only.
- **ECS Fargate** – Runs containerized app on port 8080, deployed across 2 private subnets.
- **RDS PostgreSQL** – Deployed in private subnets, secured via SGs; password stored in SSM.
- **VPC** – 2x public subnets (for ALB), 2x private subnets (for ECS & RDS), with NAT gateway.

## Requirements

- Terraform ≥ 1.3.0
- AWS CLI configured
- Valid ACM Certificate ARN for HTTPS

## Setup

```bash
terraform init
terraform plan -var 'acm_certificate_arn=arn:aws:acm:...' -out=tfplan
terraform apply tfplan
````

## Inputs

* `aws_region`: AWS Region (default: `us-west-2`)
* `project_name`: Prefix for resources (default: `devsecopsapp`)
* `environment`: Environment label (default: `dev`)
* `vpc_cidr`: VPC CIDR block (default: `10.0.0.0/16`)
* `public_subnets`: List of CIDRs for public subnets
* `private_subnets`: List of CIDRs for private subnets
* `container_image`: Docker image (e.g., `nginx`, `your-org/app`)
* `db_name`: PostgreSQL DB name
* `db_username`: DB user name
* `acm_certificate_arn`: ARN of the TLS certificate for ALB
* `tags`: Resource tags

## Outputs

* ALB DNS name for HTTPS access
* ECS cluster and service names
* RDS hostname

---

## Assumptions

* The container listens on port 8080.
* Client access is limited to `75.2.60.0/24`.
* TLS cert already exists and is managed externally (via ACM).
* The app handles database credentials from environment variables or secrets injection.

---

## Directory Structure

```
.
├── main.tf
├── variables.tf
├── modules
│   ├── vpc
│   ├── security
│   ├── rds
│   ├── ecs
│   └── alb
└── README.md
```
