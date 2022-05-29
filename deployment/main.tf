terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  profile = "default"
  region  = var.region
}

resource "random_pet" "lambda_bucket_name" {
  prefix = "rps"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
}

resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
  bucket = random_pet.lambda_bucket_name.id
  acl    = private
}
