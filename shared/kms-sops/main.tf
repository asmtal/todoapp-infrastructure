resource "aws_kms_key" "sops_key" {
  description             = "KMS key for SOPS Encryption"
  deletion_window_in_days = 10

  tags = var.tags
}