# Resource and access policy definition
data "aws_caller_identity" "current" {}

resource "aws_kms_key" "kms_key" {
  count                   = length(var.services)
  description             = "KMS key for ${var.services[count.index]}"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  multi_region            = var.multiregion
  tags = var.tags

  # Create access policy for each KMS key
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "key-policy-${lower(var.services[count.index])}",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "${data.aws_caller_identity.current.arn}"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "Allow via service",
        "Effect" : "Allow",
        "Principal" : {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : [        
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:CreateGrant",
            "kms:ListGrants",
            "kms:DescribeKey"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "kms:ViaService" : [
              "${lower(var.services[count.index])}.${var.aws_region}.amazonaws.com"
            ]
          }
        }
      }
    ]
  })
}

# Alias for each KMS key
resource "aws_kms_alias" "kms_alias" {
  count         = length(var.services)
  name          = "alias/${var.project_name}/${lower(var.services[count.index])}"
  target_key_id = aws_kms_key.kms_key[count.index].key_id
}
