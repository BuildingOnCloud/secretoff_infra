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

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}
