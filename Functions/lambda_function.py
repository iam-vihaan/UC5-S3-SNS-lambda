import os
import boto3
import urllib.parse
from PIL import Image, UnidentifiedImageError
from io import BytesIO

s3 = boto3.client('s3')
sns = boto3.client('sns')

def lambda_handler(event, context):
    try:
        # Validate environment variables
        required_vars = ['SOURCE_BUCKET', 'DEST_BUCKET', 'SNS_TOPIC_ARN']
        missing_vars = [var for var in required_vars if var not in os.environ]
        if missing_vars:
            error_msg = f"Missing environment variables: {', '.join(missing_vars)}"
            print(error_msg)
            return {'statusCode': 500, 'body': error_msg}

        config = {
            'source_bucket': os.environ['SOURCE_BUCKET'],
            'dest_bucket': os.environ['DEST_BUCKET'],
            'sns_topic_arn': os.environ['SNS_TOPIC_ARN'],
            'resize_width': int(os.environ.get('RESIZE_WIDTH', '300'))
        }

        processed_count = 0
        for record in event.get('Records', []):
            try:
                if record.get('eventSource') == 'aws:s3':
                    result = process_s3_record(record, config)
                    if result:
                        processed_count += 1
            except Exception as e:
                print(f"Error processing record: {str(e)}")
                continue

        return {
            'statusCode': 200,
            'body': f"Successfully processed {processed_count} images"
        }

    except Exception as e:
        print(f"Lambda execution failed: {str(e)}")
        return {'statusCode': 500, 'body': str(e)}

def process_s3_record(record, config):
    """Process a single S3 record"""
    try:
        # Safely extract object key with error handling
        object_key = urllib.parse.unquote(record['s3']['object']['key'])
        bucket_name = record['s3']['bucket']['name']
        
        print(f"Processing: {object_key} from {bucket_name}")

        # Validate source bucket
        if bucket_name != config['source_bucket']:
            print(f"Skipping record from unexpected bucket: {bucket_name}")
            return False

        # Validate file extension
        file_ext = os.path.splitext(object_key)[1].lower()
        if file_ext not in ['.jpg', '.jpeg', '.png']:
            print(f"Skipping non-image file: {object_key}")
            return False

        # Download and process image
        response = s3.get_object(Bucket=bucket_name, Key=object_key)
        image_data = response['Body'].read()

        # Process image with explicit format handling
        processed_image = process_image(image_data, config['resize_width'], file_ext)
        
        # Upload to destination
        dest_key = f"resized/{os.path.basename(object_key)}"
        s3.put_object(
            Bucket=config['dest_bucket'],
            Key=dest_key,
            Body=processed_image,
            ContentType=response['ContentType']
        )

        # Send notification
        sns.publish(
            TopicArn=config['sns_topic_arn'],
            Message=f"Resized {object_key} → {dest_key}"
        )
        return True

    except UnidentifiedImageError:
        print(f"Cannot identify image file: {object_key}")
        return False
    except Exception as e:
        print(f"Failed to process {object_key}: {str(e)}")
        return False

def process_image(image_data, target_width, file_ext, quality=85):
    """Process image with robust format handling"""
    try:
        with Image.open(BytesIO(image_data)) as img:
            # Use file extension if Pillow can't detect format
            img_format = img.format or file_ext[1:].upper()
            
            # Calculate new dimensions
            width_percent = target_width / float(img.size[0])
            height = int(float(img.size[1]) * width_percent)
            
            # Resize with high quality
            img = img.resize((target_width, height), Image.LANCZOS)
            
            # Save to buffer with appropriate format
            buffer = BytesIO()
            if img_format in ['JPEG', 'JPG']:
                img.save(buffer, format='JPEG', quality=quality, optimize=True)
            elif img_format == 'PNG':
                img.save(buffer, format='PNG', optimize=True)
            else:
                raise ValueError(f"Unsupported format: {img_format}")
                
            buffer.seek(0)
            return buffer.getvalue()
            
    except Exception as e:
        print(f"Image processing error: {str(e)}")
        raise
