data "aws_kms_alias" "KmsKey" {
  name = "alias/${var.KmsKeyAlias}"
}