terraform {
  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "BuildingOnCloud"
    required_providers {
        aws = {
          source = "hashicorp/aws"
          version = "3.74.2"
        }
      }

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "Lattice_Test"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_ecr_repository" "foo" {
  name                 = "bar"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
