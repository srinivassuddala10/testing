output "bucket_name" {
  value = module.s3_bucket.s3_bucket_id
}

output "bucket_website_endpoint" {
  value = module.s3_bucket.s3_bucket_website_endpoint
}

output "bucket_website_domain" {
  value = module.s3_bucket.s3_bucket_website_domain
}

output "rds" {
  value       = aws_db_instance.postgres_instance
  description = "The endpoint of the PostgreSQL RDS instance"
  sensitive   = true
}

