# ============================================================================
# terraform/modules/storage/outputs.tf
# ============================================================================

output "efs_id" {
  description = "EFS file system ID"
  value       = aws_efs_file_system.main.id
}

output "efs_access_point_id" {
  description = "EFS access point ID"
  value       = aws_efs_access_point.main.id
}