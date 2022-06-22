terraform {
  # Define a specific Terraform version to be used. This is needed to prevent
  # inadvertent changes to state by people running different versions. Advise
  # use of "tfenv" to manage installed Terraform versions.
  required_version = "0.14.0"

  # Specify minimum required provider versions.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.19.0"
    }
  }

  # Normally I'd suggest using DynamoDB with an S3 backup for this in a
  # production capacity, but since we're prototyping...
  backend "s3" {
    bucket = "tfstate-rm-proto"
    key    = "terraform/state"
    region = "us-east-1"
  }
}

# Set our region for the AWS provider.
provider "aws" {
  region = "us-east-1"
}
