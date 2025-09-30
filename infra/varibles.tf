# Common variables used across resources
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "aus-west-2"
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key"
  type        = string
}

variable "aws_account_id" {
  type    = string
  default = "338220915527"
}

variable "app_name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "environment" {
  description = "Enironment name for which the resources are being provisioned. Ex., DEV, QA, PROD"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-03aa99ddf5498ceb9"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t3.small"
}

variable "key_name" {
  description = "Name of the key pair for SSH access"
}

variable "disk_size" {
  description = "Disk size in GB"
  default     = 50
}

variable "blazeops_frontend_app_domain_name" {
  description = "frontend app domain name"
  type        = string
}

variable "vpc_cidr" {
  type    = string
  default = "vpc cidr range"
}

variable "postgress_password" {
  type        = string
  description = "postgress db password"
}

variable "zone_id" {
  type    = string
  default = "Z0575084ABG06L55NR3H"
}
