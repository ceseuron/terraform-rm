# Get available zones for our target region.
data "aws_availability_zones" "available_zones" {}

# Define the AWS VPCs to be set up for the prototype environment.
# Source: https://github.com/terraform-aws-modules/terraform-aws-vpc
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "rm-vpc-us-east-1"
  cidr = "10.128.0.0/16"

  azs                = data.aws_availability_zones.available_zones.names
  private_subnets    = ["10.128.1.0/24", "10.128.2.0/24", "10.128.3.0/24"]
  public_subnets     = ["10.128.101.0/24", "10.128.102.0/24", "10.128.103.0/24"]
  enable_nat_gateway = "true"

  tags = {
    Terraform   = "true"
    Environment = "prototype"
  }
}
