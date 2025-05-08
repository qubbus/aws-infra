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
```

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
├── README.md
└── terraform
    ├── data.tf
    ├── main.tf
    ├── modules
    │   ├── alb
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── ecs
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   ├── rds
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   └── security
    │       ├── main.tf
    │       ├── outputs.tf
    │       └── variables.tf
    ├── outputs.tf
    ├── providers.tf
    └── variables.tf
```

## Future Improvements

The current implementation meets the basic requirements but could be enhanced further:

### Security Improvements
- [ ] Implement AWS WAF for the ALB to protect against common web exploits
- [ ] Add GuardDuty for threat detection
- [ ] Implement AWS Config Rules for compliance monitoring
- [ ] Use AWS Secrets Manager instead of SSM Parameter Store for better secrets rotation
- [ ] Enable encryption at rest for all resources (S3, EBS, RDS)
- [ ] Add VPC Flow Logs for network monitoring
- [ ] Implement more granular IAM permissions following least privilege principle

### Reliability Improvements
- [ ] Configure Multi-AZ for RDS to improve availability
- [ ] Set up ECS auto-scaling based on CPU/memory utilization
- [ ] Implement health checks and circuit breakers in the application
- [ ] Add disaster recovery strategy with data backups
- [ ] Create CloudWatch alarms for critical metrics
- [ ] Implement Route 53 health checks and failover routing

### Operational Improvements
- [ ] Add CloudWatch Logs configuration for application logs
- [ ] Implement proper tagging strategy for all resources
- [ ] Set up CI/CD pipeline for infrastructure changes
- [ ] Create infrastructure documentation with diagrams
- [ ] Add cost optimization recommendations
- [ ] Implement infrastructure testing

### Compliance Improvements
- [ ] Add automated compliance checks for security best practices
- [ ] Implement AWS Config for configuration compliance
- [ ] Add data classification and handling procedures
- [ ] Implement audit logging for all infrastructure changes
