terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region = var.region
}

resource "random_pet" "lambda_bucket_name" {
  prefix = "rps"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
}

resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

module "lambda_function" {
  source = "./modules/lambda"

  function_name = "rps"
  source_path   = "${path.root}/../src"
  output_path   = "${path.root}/../src.zip"
  bucket        = aws_s3_bucket.lambda_bucket.id
  key           = "src.zip"
  handler       = "handler.rps"
}
