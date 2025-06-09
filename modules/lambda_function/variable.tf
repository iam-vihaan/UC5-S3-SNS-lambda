
variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "role_arn" {
  description = "ARN of the IAM role for Lambda"
  type        = string
}

variable "runtime" {
  description = "Lambda runtime (e.g., python3.9)"
  type        = string
  default     = "python3.9"
}

variable "handler" {
  description = "Lambda handler (e.g., lambda_function.lambda_handler)"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "filename" {
  description = "Path to the deployment package"
  type        = string
}

variable "source_bucket_name" {
  description = "Name of the source S3 bucket"
  type        = string
}

variable "dest_bucket_name" {
  description = "Name of the destination S3 bucket"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic"
  type        = string
}

variable "resize_width" {
  description = "Width to resize images to"
  type        = number
}

variable "memory_size" {
  description = "Memory allocation in MB"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Timeout in seconds"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
