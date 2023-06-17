variable "bucket-name" {
  type    = string
  default = "file-notification-bpw-github-tests"
}

variable "lambda-function-name" {
  type    = string
  default = "s3_file_notification"
}

variable "lambda-runtime" {
  type = string
  default = "python3.9"
}

variable "notification-prefix" {
  type = string
  default = ""
  description = "Prefix of files to activate lambda function"
}

variable "notification-suffix" {
  type = string
  default = ""
  description = "Suffix of files to activate lambda function"
}