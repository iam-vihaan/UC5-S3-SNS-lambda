variable "role_name" {
  description = "The name of the IAM role"
  type        = string
}

variable "policy_name" {
  description = "The name of the IAM policy"
  type        = string
}

variable "source_bucket_arn" {
  description = "The source S3 bucket"
  type        = string
}

variable "dest_bucket_arn" {
  description = "The destination S3 bucket"
  type        = string
}


variable "sns_topic_arn" {
  description = "The SNS topic ARN"
  type        = string
}
