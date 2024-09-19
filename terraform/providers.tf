# providers.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "digitify"
    key            = "digitify/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-locking"
  }
}

provider "aws" {
  region = "us-west-2"  # Set your AWS region

  # Assume the specified IAM role
  assume_role {
    role_arn = "arn:aws:iam::670912381891:role/ecr-digitify-role"  # The role to assume
  }
}
