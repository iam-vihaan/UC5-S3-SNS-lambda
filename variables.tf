variable "source_bucket_name" {
  type    = string
  default = "source-bucket-image-original"
}


variable "processed_bucket_name" {
  type    = string
  default = "dest-bucket-image-processed"
}


variable "sns_topic_name" {
  type    = string
  default = "image-topic"
}

variable "lambda_function_name" {
  type    = string
  default = "lambda-image-resize"
}

variable "resize_width" {
  type    = number
  default = 600
}

variable "tags" {
  type = map(string)
  default = {
    Project   = "ImageProcessor"
    Owner     = "prodTeam"
    ManagedBy = "Terraform"
  }
}

variable "email" {
  type    = string
  default = "anilkumar.padarthi@hcltech.com"
}

variable "lambda_role" {
  type    = string
  default = "lambda_role_s3_image"
}


variable "environment" {
  description = "The environment for the resources (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "enable_versioning" {
  type        = bool
  default     = true
  description = "Enable versioning on the S3 buckets"
}
