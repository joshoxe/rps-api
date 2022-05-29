terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16.0"
    }
  }

  backend "s3" {
    bucket = aws_s3_bucket.lambda_bucket.name
    key    = "tf.tfstate"
    region = var.region
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "rps-lambda-api-s3"
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
