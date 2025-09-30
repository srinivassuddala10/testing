variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "my_ec2"
  type        = string
  default     = "t2.micro"
}

variable "bucket_name" {
  description = "my_bucket"
  type        = string
}
