resource "aws_apigatewayv2_api" "lambda_gateway" {
  name          = var.gateway_name
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda_gateway_stage" {
  api_id = aws_apigatewayv2_api.lambda_gateway.id

  name        = "${var.gateway_name}_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "lambda_function" {
  api_id = aws_apigatewayv2_api.lambda_gateway.id

  integration_uri    = var.lambda_invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "lambda_route" {
  api_id = aws_apigatewayv2_api.lambda_gateway.id

  route_key = "${var.request_method} ${var.request_path}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_function.id}"
}

resource "aws_cloudwatch_log_group" "api_logs" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda_gateway.name}"

  retention_in_days = var.log_retention_days
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda_gateway.execution_arn}/*/*"
}
