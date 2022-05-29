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
