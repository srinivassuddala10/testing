provider "aws" {
  region = var.aws_region
}

# S3 Bucket
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "my-unique-frontend-bucket-12345"
  acl    = "private"
}

# EC2 instance
resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316" # update with valid AMI
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-ec2"
  }
}

# RDS Postgres
resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "15.2"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "admin"
  password             = "Password123!"
  skip_final_snapshot  = true
  publicly_accessible  = false
}
