variable "gateway_name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "The full URI of the lambda function to invoke"
  type        = string
}

variable "route_key" {
  description = "The route key for the websocket gateway"
  type        = string
}

variable "log_retention_days" {
  description = "How long to retain gateway logs"
  type        = number
  default     = 30
}

variable "function_name" {
  description = "Name of the function for the gateway to invoke"
  type        = string
}
