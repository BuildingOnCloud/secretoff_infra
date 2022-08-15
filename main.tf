terraform {
  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "BuildingOnCloud"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "Lattice_Test"
    }
  }
}

# An example resource that does nothing.
resource "null_resource" "example" {
  triggers = {
    value = "A example resource that does nothing!"
  }
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
