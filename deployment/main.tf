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

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = "priv_vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "education"
  subnet_ids = module.vpc.private_subnets
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

