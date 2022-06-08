data "archive_file" "lambda_zip_contents" {
  type = "zip"

  source_dir  = var.source_path
  output_path = var.output_path
}

resource "aws_s3_object" "lambda_zip_upload" {
  bucket = var.bucket

  key    = var.key
  source = data.archive_file.lambda_zip_contents.output_path

  etag = filemd5(data.archive_file.lambda_zip_contents.output_path)
}

resource "aws_lambda_function" "lambda_function" {
  function_name = var.function_name

  runtime = "nodejs12.x"
  handler = var.handler

  source_code_hash = data.archive_file.lambda_zip_contents.output_base64sha256

  role = aws_iam_role.lambda_exec.arn

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  environment {
    variables = {
      PGUSER     = var.db_user
      PGHOST     = var.db_host
      PGPASSWORD = var.db_password
      PGDATABASE = var.db
      PGPORT     = var.db_port
    }
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"

  retention_in_days = var.log_retention_days
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.function_name}-serverless-lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_execute_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
