# --------------------------
# S3 Bucket
# --------------------------
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "my-frontend-bucket"
}

resource "aws_s3_bucket_acl" "frontend_bucket_acl" {
  bucket = aws_s3_bucket.frontend_bucket.id
  acl    = "private"
}

# --------------------------
# EC2 Instance
# --------------------------
resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316" # Replace with a valid AMI in your region
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-ec2"
  }
}

# --------------------------
# RDS Instance
  ---------------------------
resource "aws_db_instance" "postgres" {
  engine         = "postgres"
  engine_version = "15.3"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  db_name        = "mydb"          # ✅ use db_name
  username       = "admin"
  password       = "Admin12345"
  publicly_accessible = false
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  subnet_group_name      = aws_db_subnet_group.default.name
}

