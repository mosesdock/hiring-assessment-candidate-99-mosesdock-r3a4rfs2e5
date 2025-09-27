# ============================================================================
# terraform/modules/storage/main.tf
# ============================================================================

resource "aws_security_group" "efs" {
  name        = "${var.project_name}-${var.environment}-efs-sg"
  description = "Security group for EFS"
  vpc_id      = var.vpc_id
  
  ingress {
    description     = "NFS from ECS"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [var.ecs_security_group_id]
  }
  
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-efs-sg"
  })
}

resource "aws_efs_file_system" "main" {
  creation_token = "${var.project_name}-${var.environment}-efs"
  
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = true
  
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  
  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-efs"
  })
}

resource "aws_efs_mount_target" "main" {
  count = length(var.subnet_ids)
  
  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_access_point" "main" {
  file_system_id = aws_efs_file_system.main.id
  
  posix_user {
    uid = 1000
    gid = 1000
  }
  
  root_directory {
    path = "/wiki-data"
    
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "755"
    }
  }
  
  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-efs-ap"
  })
}