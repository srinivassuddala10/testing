resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "my-frontend-bucket"
}

# ---------------------------
# Backend API EC2 instance
resource "aws_instance" "backend_ec2" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t3.micro"
}

# --------------------------
# RDS Instance
# ---------------------------
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

