# ============================================================================
# terraform/outputs.tf
# ============================================================================

output "application_url" {
  description = "URL to access Wiki.js"
  value       = "http://${module.compute.alb_dns_name}"
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.compute.alb_dns_name
}

output "database_endpoint" {
  description = "RDS database endpoint"
  value       = module.database.endpoint
  sensitive   = true
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.compute.ecs_cluster_name
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}