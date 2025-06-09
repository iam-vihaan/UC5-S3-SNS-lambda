variable "source_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}


variable "environment" {
  description = "The name of the S3 bucket"
  type        = string
}



variable "force_destroy" {
  type        = bool
  default     = false
  description = "Force destroy the bucket"
}

variable "enable_versioning" {
  type        = bool
  default     = true
  description = "Enable versioning on the bucket"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the bucket"
}


variable "processed_bucket_name" {
  description = "The name of the processed S3 bucket"
  type        = string

}
