terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.48.0"
    }
  }
}

module "vpn" {
  source = "./vpn"

  vpc_name          = var.vpc_name
  cidr_block        = var.cidr_block
  customer_gateways = var.customer_gateways
}
