# S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
}

# EC2 instance
resource "aws_instance" "my_ec2" {
  ami           = "ami-08c40ec9ead489470" # Amazon Linux 2 in us-east-1
  instance_type = var.instance_type

  tags = {
    Name = "MyEC2"
  }
}
