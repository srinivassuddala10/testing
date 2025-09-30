module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.2.2"

  bucket                   = var.blazeops_frontend_app_domain_name
  control_object_ownership = true
  attach_policy            = true
  block_public_policy      = false
  block_public_acls        = false
  ignore_public_acls       = false
  restrict_public_buckets  = false
  force_destroy            = true # This will delete all objects in the bucket before deletion
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "S3BucketGetObjects"
        Effect    = "Allow"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${var.blazeops_frontend_app_domain_name}/*"
        Principal = "*"
      }
    ]
  })

  website = {
    index_document = "index.html"
    error_document = "index.html"
  }

  server_side_encryption_configuration = {
    rule = [
      {
        bucket_key_enabled = true
      }
    ]
  }

  tags = {
    Environment = var.environment
    App         = var.app_name
    Name        = var.blazeops_frontend_app_domain_name
  }
}
