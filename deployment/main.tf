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
  intra_subnets        = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "db_subnet"
  subnet_ids = module.vpc.intra_subnets
}

module "lambda_connect_function" {
  source = "./modules/lambda"

  function_name      = "rps-connect"
  source_path        = "${path.root}/../src"
  output_path        = "${path.root}/../src.zip"
  bucket             = aws_s3_bucket.lambda_bucket.id
  key                = "src.zip"
  handler            = "onConnect.connect"
  subnet_ids         = module.vpc.intra_subnets
  security_group_ids = [module.vpc.default_security_group_id]
}

module "lambda_disconnect_function" {
  source = "./modules/lambda"

  function_name      = "rps-disconnect"
  source_path        = "${path.root}/../src"
  output_path        = "${path.root}/../src.zip"
  bucket             = aws_s3_bucket.lambda_bucket.id
  key                = "src.zip"
  handler            = "onDiconnect.disconnect"
  subnet_ids         = module.vpc.intra_subnets
  security_group_ids = [module.vpc.default_security_group_id]
}

module "lambda_play_function" {
  source = "./modules/lambda"

  function_name      = "rps-play"
  source_path        = "${path.root}/../src"
  output_path        = "${path.root}/../src.zip"
  bucket             = aws_s3_bucket.lambda_bucket.id
  key                = "src.zip"
  handler            = "handler.rps"
  subnet_ids         = module.vpc.intra_subnets
  security_group_ids = [module.vpc.default_security_group_id]
}

module "lambda_api_gateway" {
  source = "./modules/api-gateway"

  gateway_name                 = "lambda_gateway"
  lambda_play_invoke_arn       = module.lambda_play_function.invoke_arn
  lambda_connect_invoke_arn    = module.lambda_connect_function.invoke_arn
  lambda_disconnect_invoke_arn = module.lambda_disconnect_function.invoke_arn
  route_key                    = "rps"
  function_play_name           = module.lambda_play_function.function_name
  function_connect_name        = module.lambda_connect_function.function_name
  function_disconnect_name     = module.lambda_disconnect_function.function_name
}

resource "aws_security_group" "rds" {
  name   = "rps-rds"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rps_rds"
  }
}

resource "aws_db_parameter_group" "rds_params" {
  name   = "rps-rds"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "rds_db" {
  identifier             = "rds-rps-db"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14.1"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.rds_params.name
  skip_final_snapshot    = true
}
