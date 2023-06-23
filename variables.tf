variable "aws_region" {
  description = "AWS region where the EC2 instance will be deployed"
  type        = string
  default     = "us-east-1"
  validation {
    condition     = can(regex("^([a-z]{2}-[a-z]+-[0-9]{1})$", var.aws_region))
    error_message = "Invalid AWS region format. Please provide a valid region in the format 'us-west-2'."
  }
}

variable "number_of_keys" {
  description = "Number of KMS keys to create"
  type        = number
  default     = 1
  validation {
    condition     = var.number_of_keys > 0 && var.number_of_keys <= 10
    error_message = "The number of keys must be greater than 0 and less than or equal to 10."
  }
}

variable "project_name" {
  type        = string
  description = "Name of the project"
  default     = "my-project"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Invalid project name. Please provide a valid name using lowercase letters and hyphens (-)."
  }
}

variable "services" {
  description = "Services to encrypt using the keys"
  type        = list(string)
  default     = ["S3", "RDS", "MSK", "CloudWatch", "EBS"]
  validation {
    condition     = length(var.services) > 0
    error_message = "Please specify at least one service."
  }
}

variable "deletion_window_in_days" {
  description = "Deletion window in days"
  type        = number
  default     = 30
  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "The deletion window must be between 7 and 30 days."
  }
}

variable "enable_key_rotation" {
  description = "Enable key rotation"
  type        = bool
  default     = true
}

variable "multiregion" {
  description = "Enable multi-region key"
  type        = bool
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to AWS resources"
  default     = {
    Environment = "Development"
    Owner       = "Frankin Garcia"
  }
}