resource "aws_s3_bucket" "original_images" {
  bucket        = var.source_bucket_name
  force_destroy = var.force_destroy

  tags = {
    Name        = var.source_bucket_name
    Environment = var.environment
    Purpose     = "Source images storage"
  }
}


resource "aws_s3_bucket" "processed_images" {
  bucket        = var.processed_bucket_name
  force_destroy = var.force_destroy

  tags = {
    Name        = var.processed_bucket_name
    Environment = var.environment
    Purpose     = "Source images storage"
  }
}


# Configure versioning for source bucket
resource "aws_s3_bucket_versioning" "source_versioning" {
  bucket = aws_s3_bucket.original_images.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}


# Configure versioning for source bucket
resource "aws_s3_bucket_versioning" "processed_versioning" {
  bucket = aws_s3_bucket.processed_images.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}


