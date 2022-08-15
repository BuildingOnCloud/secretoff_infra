terraform {
  cloud {
    organization = "BuildingOnCloud"

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
