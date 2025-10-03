# ---------------------------
# VPC
# ---------------------------
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

# ---------------------------
# Subnet
# ---------------------------
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "main-subnet"
  }
}

# ---------------------------
# Security Group for EC2
# ---------------------------
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------------
# Security Group for RDS
# ---------------------------
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow Postgres access"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # restrict as needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------------
# EC2 Instance
# ---------------------------
resource "aws_instance" "web" {
  ami           = "ami-0abcdef1234567890"  # replace with your region AMI
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.ec2_sg.name]

  tags = {
    Name = "WebServer"
  }
}

# ---------------------------
# S3 Bucket for Frontend
# ---------------------------
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "my-frontend-bucket-unique-name-123" # must be globally unique
}

# ---------------------------
# DB Subnet Group
# ---------------------------
resource "aws_db_subnet_group" "default" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.main.id]

  tags = {
    Name = "my-db-subnet-group"
  }
}

# ---------------------------
# RDS PostgreSQL Instance
# ---------------------------
resource "aws_db_instance" "postgres" {
  identifier             = "my-postgres-db"
  engine                 = "postgres"
  engine_version         = "15.3"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = "admin"
  password               = "YourStrongPassword123"
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
}
