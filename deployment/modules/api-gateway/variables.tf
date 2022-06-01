variable "gateway_name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "The full URI of the lambda function to invoke"
  type        = string
}

variable "request_method" {
  description = "The HTTP method to accept for this gateway"
  type        = string
}

variable "request_path" {
  description = "The path to match for the gateway. Example: '/hello' to invoke the lambda on requests to /hello"
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
