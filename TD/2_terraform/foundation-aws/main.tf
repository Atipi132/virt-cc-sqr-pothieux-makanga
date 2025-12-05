terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west9"
}

# Create a VPC
resource "aws_vpc" "aws_vpc1" {
  cidr_block = "10.0.0.0/24"
}
