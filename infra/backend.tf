terraform {
  backend "s3" {
    bucket         = "my-terraform-backend-bucket"   # S3 bucket name
    key            = "env/dev/terraform.tfstate"     # Path in bucket (acts like a folder/file)
    region         = "us-east-2"                     # Region of the S3 bucket
    dynamodb_table = "terraform-locks"               # DynamoDB table for state locking
    encrypt        = true                            # Encrypt the state file
  }
}
