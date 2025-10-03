resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "my-frontend-bucket"
}

# ---------------------------
resource "aws_instance" "web" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.main.id  # reference your subnet
  security_groups = [aws_security_group.ec2_sg.name]  # reference a valid SG

  tags = {
    Name = "WebServer"
  }
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

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow Postgres access"
  vpc_id      = aws_vpc.main.id  # make sure you have a VPC defined

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # adjust for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

