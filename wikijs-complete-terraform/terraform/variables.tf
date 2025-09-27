# ============================================================================
# terraform/variables.tf
# ============================================================================

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "il-central-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "wikijs"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "alert_email" {
  description = "Email address for monitoring alerts"
  type        = string
  default     = ""
}