resource "aws_apigatewayv2_api" "lambda_gateway" {
  name                       = var.gateway_name
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_stage" "lambda_gateway_stage" {
  api_id = aws_apigatewayv2_api.lambda_gateway.id

  name        = "${var.gateway_name}_live"
  auto_deploy = true
  default_route_settings {
    throttling_burst_limit = 1000
    throttling_rate_limit  = 500
  }
}

resource "aws_apigatewayv2_integration" "lambda_connect_integration" {
  api_id = aws_apigatewayv2_api.lambda_gateway.id

  integration_uri    = var.lambda_connect_invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_integration" "lambda_disconnect_integration" {
  api_id = aws_apigatewayv2_api.lambda_gateway.id

  integration_uri    = var.lambda_disconnect_invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_integration" "lambda_play_integration" {
  api_id = aws_apigatewayv2_api.lambda_gateway.id

  integration_uri    = var.lambda_play_invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "lambda_connect_route" {
  api_id = aws_apigatewayv2_api.lambda_gateway.id

  route_key = "$connect"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_connect_integration.id}"
}

resource "aws_apigatewayv2_route" "lambda_disconnect_route" {
  api_id = aws_apigatewayv2_api.lambda_gateway.id

  route_key = "$disconnect"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_disconnect_integration.id}"
}

resource "aws_apigatewayv2_route" "lambda_play_route" {
  api_id = aws_apigatewayv2_api.lambda_gateway.id

  route_key = var.route_key
  target    = "integrations/${aws_apigatewayv2_integration.lambda_play_integration.id}"
}

resource "aws_cloudwatch_log_group" "api_logs" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda_gateway.name}"

  retention_in_days = var.log_retention_days
}

resource "aws_lambda_permission" "api_play_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.function_play_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda_gateway.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_connect_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.function_connect_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda_gateway.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_disconnect_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.function_disconnect_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda_gateway.execution_arn}/*/*"
}
