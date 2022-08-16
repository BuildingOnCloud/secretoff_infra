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


resource "aws_kms_key" "secretoff_kms_key" {
  description             = "KMS for secretoff app cloudwatch config"
  deletion_window_in_days = 7
}

# CloudWathc Config
resource "aws_cloudwatch_log_group" "app_cloudwatch" {
  name = "secretoff_app_logroup"
}

resource "aws_ecs_cluster" "secretoff_cluster" {
  name = "app_cluster1"

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.secretoff_kms_key.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.app_cloudwatch.name
      }
    }
  }
}
