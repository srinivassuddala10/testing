# Create the RDS security group (optional but recommended for security)
resource "aws_security_group" "rds_sg" {
  name        = "${var.app_name}-${var.environment}-rds-security-group"
  description = "Allow PostgreSQL inbound traffic"
  vpc_id      = module.blazeops_vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # You can restrict this to specific IP ranges for better security
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the PostgreSQL RDS instance
resource "aws_db_instance" "postgres_instance" {
  identifier             = "${var.app_name}-${var.environment}-postgres-db-instance"
  engine                 = "postgres"
  engine_version         = "17.4"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "blazeops"
  username               = "blazeops"
  password               = var.postgress_password
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  storage_type           = "gp2"
  multi_az               = false
  #storage_encrypted       = true
  final_snapshot_identifier = "${var.app_name}-${var.environment}-postgres-db-final-snapshot"
  tags = {
    Environment = var.environment
    App         = var.app_name
    Name        = "${var.app_name}-${var.environment}-postgres-db-instance"
  }
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "${var.app_name}-${var.environment}-subnet"
  subnet_ids = module.blazeops_vpc.private_subnets

  tags = {
    Environment = var.environment
    App         = var.app_name
    Name        = "${var.app_name}-${var.environment}-postgres-db-subnet-group"
  }
}

# Create a DB Subnet Group for RDS (public subnet)
#resource "aws_db_subnet_group" "public" {
#  name       = "${var.app_name}-${var.environment}-postgres-db-subnet-group"
#  subnet_ids = module.vpc.public_subnets

#  tags = {
#    Environment = var.environment
#    App         = var.app_name
#    Name        = "${var.app_name}-${var.environment}-postgres-db-subnet-group"
#  }
#}
