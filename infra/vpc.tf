module "blazeops_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"

  name = "${var.app_name}-${var.environment}-vpc"
  cidr = var.vpc_cidr

  azs             = ["us-west-2a", "us-west-2b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  # NAT gateway for private subnets
  enable_nat_gateway = true
  single_nat_gateway = true


  tags = {
    Environment = var.environment
    App         = var.app_name
    Name        = "${var.app_name}-${var.environment}-vpc"
  }
}
