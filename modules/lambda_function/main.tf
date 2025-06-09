resource "aws_lambda_function" "image_resizer" {
  function_name    = var.function_name
  description      = "Resizes images uploaded to S3"
  role             = var.role_arn
  runtime          = var.runtime
  handler          = var.handler
  filename         = var.filename
  memory_size      = var.memory_size
  timeout          = var.timeout
  publish          = true
  source_code_hash = (var.filename)

  environment {
    variables = {
      SOURCE_BUCKET = var.source_bucket_name # Changed to match Lambda
      DEST_BUCKET   = var.dest_bucket_name   # Changed from RESIZED_BUCKET_NAME
      SNS_TOPIC_ARN = var.sns_topic_arn      # Kept consistent
      RESIZE_WIDTH  = var.resize_width       # Kept consistent
    }
  }
  tags = var.tags
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_resizer.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.source_bucket_name}"
}

resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = var.source_bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_resizer.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3, aws_lambda_function.image_resizer]
}
