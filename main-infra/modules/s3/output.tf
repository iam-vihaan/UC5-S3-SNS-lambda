output "original_images_bucket_id" {
  description = "ID of the original images S3 bucket"
  value       = aws_s3_bucket.original_images.id
}

output "original_images_bucket_name" {
  description = "Name of the original images S3 bucket"
  value       = aws_s3_bucket.original_images.bucket
}

output "original_images_bucket_arn" {
  description = "ARN of the original images S3 bucket"
  value       = aws_s3_bucket.original_images.arn
}




output "processed_images_bucket_id" {
  description = "ID of the processed images S3 bucket"
  value       = aws_s3_bucket.processed_images.id
}

output "processed_images_bucket_name" {
  description = "Name of the processed images S3 bucket"
  value       = aws_s3_bucket.processed_images.bucket
}

output "processed_images_bucket_arn" {
  description = "ARN of the processed images S3 bucket"
  value       = aws_s3_bucket.processed_images.arn
}
