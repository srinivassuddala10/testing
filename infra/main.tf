# ---------------------------
# VPC
# ---------------------------
data "aws_vpc" "existing" {
  default = true
}

# Then use data.aws_vpc.existing.id for subnets/security groups

# ---------------------------
# Subnet
# ---------------------------
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "main-subnet"
  }
}

# ---------------------------
# Internet Gateway
# ---------------------------
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# ---------------------------
# Route Table
# ---------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "main-public-rt"
  }
}

# ---------------------------
# Route Table Association
# ---------------------------
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.public.id
}

# ---------------------------
# Security Group for EC2
# ---------------------------
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access"
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

  tags = {
    Name = "ec2-sg"
  }
}

# ---------------------------
# Security Group for RDS
# ---------------------------
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow PostgreSQL access from EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# ---------------------------
# EC2 Instance
# ---------------------------
resource "aws_instance" "web" {
  ami                         = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.main.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  key_name                    = "my-keypair" # <-- replace with your EC2 key pair name

  tags = {
    Name = "WebServer"
  }
}

# ---------------------------
# S3 Bucket for Frontend
# ---------------------------
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "my-frontend-bucket-${random_id.bucket_id.hex}"  # unique suffix
}

resource "random_id" "bucket_id" {
  byte_length = 4
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

  tags = {
    Name = "PostgresDB"
  }
}
