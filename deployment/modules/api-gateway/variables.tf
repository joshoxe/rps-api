variable "gateway_name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "lambda_play_invoke_arn" {
  description = "The function to invoke for play events"
  type        = string
}

variable "lambda_connect_invoke_arn" {
  description = "The function to invoke for connect events"
  type        = string
}

variable "lambda_disconnect_invoke_arn" {
  description = "The function to invoke for disconnect events"
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

variable "function_play_name" {
  description = "Name of the play function for the gateway to invoke"
  type        = string
}

variable "function_connect_name" {
  description = "Name of the connect function for the gateway to invoke"
  type        = string
}

variable "function_disconnect_name" {
  description = "Name of the disconnect function for the gateway to invoke"
  type        = string
}
