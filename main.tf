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

provider "aws" {}

resource "aws_ecr_repository" "foo" {
  name                 = "bar"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
