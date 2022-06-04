variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_host" {
  description = "Hostname of the postgres DB instance"
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
