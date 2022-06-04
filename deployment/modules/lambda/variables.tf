variable "source_path" {
  description = "Path to the source NodeJS files to zip"
  type        = string
}

variable "output_path" {
  description = "Path to output the zipped content"
  type        = string
}

variable "bucket" {
  description = "ID of the S3 bucket to use for the function"
}

variable "key" {
  description = "Full path of the content that the function will use"
  type        = string
}

variable "function_name" {
  description = "The name of the function"
  type        = string
}

variable "handler" {
  description = "The function to run on entry"
  type        = string
}

variable "log_retention_days" {
  description = "How long to retain function logs"
  type        = number
  default     = 30
}

variable "subnet_ids" {
  description = "IDs of the VPC subnet"
  type        = set(string)
}

variable "security_group_ids" {
  description = "IDs of the security groups for the VPC"
  type        = set(string)
}

variable "db_user" {
  description = "Username of the postgres DB instance"
  type        = string
}

variable "db_host" {
  description = "Hostname of the postgres DB instance"
  type        = string
}

variable "db_password" {
  description = "Password for the postgres DB instance"
  type        = string
}

variable "db" {
  description = "Name of the database to access"
  type        = string
}

variable "db_port" {
  description = "Port of the postgres DB"
  type        = number
}



