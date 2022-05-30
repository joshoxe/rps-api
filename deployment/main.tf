terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16.0"
    }
  }

  backend "s3" {
    bucket = "state-lock-rps-s3"
    key    = "tf.tfstate"
    region = "eu-west-2"
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

module "lambda_api_gateway" {
  source = "./modules/api-gateway"

  gateway_name      = "lambda_gateway"
  lambda_invoke_arn = module.lambda_function.invoke_arn
  request_method    = "POST"
  request_path      = "/api"
  function_name     = module.lambda_function.function_name
}
