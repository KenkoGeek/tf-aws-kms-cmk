# Output the ARNs of the created KMS keys
output "kms_key_arns" {
  description = "ARNs of the created KMS keys with service names as a map"
  value       = { for index, kms_key in aws_kms_key.kms_key : var.services[index] => kms_key.arn }
}
