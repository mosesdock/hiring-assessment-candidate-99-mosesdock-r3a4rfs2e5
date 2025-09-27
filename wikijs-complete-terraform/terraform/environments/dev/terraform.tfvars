# ============================================================================
# terraform/environments/dev/terraform.tfvars
# ============================================================================

aws_region   = "il-central-1"
environment  = "dev"
project_name = "wikijs"
vpc_cidr     = "10.0.0.0/16"

# Optional: Add your email for CloudWatch alerts
# alert_email = "your-email@example.com"