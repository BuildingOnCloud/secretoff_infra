terraform {
  cloud {
    organization = "BuildingOnCloud"

    workspaces {
      name = "Lattice_Test"
    }
  }
}

# AWS Setup
provider "aws" {
  region = "us-east-1"
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
}

# Docker Registry
resource "aws_ecr_repository" "secretoff_registry" {
  name                 = "app_registry1"
  image_tag_mutability = "MUTABLE"
  
  image_scanning_configuration {
    scan_on_push = true
  }
}
