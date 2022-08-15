terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.26.0"
    }
  }

  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "BuildingOnCloud"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "Lattice_Test"
    }
  }
}

provider "aws" {
  # Configuration options
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
