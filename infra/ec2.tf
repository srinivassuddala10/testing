# Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  name        = "${var.app_name}-${var.environment}-backend-api"
  description = "Allow SSH and HTTP access"
  vpc_id      = module.blazeops_vpc.vpc_id

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

  ingress {
    from_port   = 8000
    to_port     = 8000
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

# EC2 Instance
resource "aws_instance" "ec2_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = module.blazeops_vpc.public_subnets[0]
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  root_block_device {
    volume_size = var.disk_size
    volume_type = "gp3"
  }

  user_data = <<-EOT
              #!/bin/bash
              apt-get update -y
              sudo apt install -y postgresql-client -y
              sudo apt install unzip curl -y
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              sudo ./aws/install
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ubuntu
              EOT

  tags = {
    Name = "blazeops-backend-api"
  }
}

# Output the EC2 instance public IP
output "ec2_public_ip" {
  value       = aws_instance.ec2_instance.public_ip
  description = "The public IP of the EC2 instance"
}


output "vpc_id" {
  value = module.blazeops_vpc.vpc_id
}

output "subnet_id" {
  value = module.blazeops_vpc.vpc_id
}
