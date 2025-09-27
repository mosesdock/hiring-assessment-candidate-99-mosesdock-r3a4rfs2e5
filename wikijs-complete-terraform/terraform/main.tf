# ============================================================================
# terraform/main.tf
# ============================================================================

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Region      = var.aws_region
  }
}

module "networking" {
  source = "./modules/networking"
  
  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  
  tags = local.common_tags
}

module "security" {
  source = "./modules/security"
  
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
  
  tags = local.common_tags
}

module "database" {
  source = "./modules/database"
  
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
  subnet_ids   = module.networking.private_subnet_ids
  
  ecs_security_group_id = module.security.ecs_security_group_id
  
  tags = local.common_tags
}

module "storage" {
  source = "./modules/storage"
  
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
  subnet_ids   = module.networking.private_subnet_ids
  
  ecs_security_group_id = module.security.ecs_security_group_id
  
  tags = local.common_tags
}

module "compute" {
  source = "./modules/compute"
  
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
  
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  
  alb_security_group_id = module.security.alb_security_group_id
  ecs_security_group_id = module.security.ecs_security_group_id
  
  database_endpoint      = module.database.endpoint
  database_name          = module.database.database_name
  database_username      = module.database.username
  database_password_arn  = module.database.password_secret_arn
  
  efs_file_system_id = module.storage.efs_id
  
  tags = local.common_tags
  
  depends_on = [module.database, module.storage]
}

module "monitoring" {
  source = "./modules/monitoring"
  
  project_name = var.project_name
  environment  = var.environment
  
  ecs_cluster_name = module.compute.ecs_cluster_name
  ecs_service_name = module.compute.ecs_service_name
  alb_arn         = module.compute.alb_arn
  
  alert_email = var.alert_email
  
  tags = local.common_tags
}
