variable "aws_region" {
  description = "AWS region"
  default     = "eu-west-3"
}

variable "dynamodb" {
  description = "Variable for dynamodb table, as you can see, padavan"
  type        = string
  default     = "aws-terraform-states-lock"
}

variable "state_bucket" {
  description = "Var for S3 bucket to save .tfstate file. Should be unique"
  type        = string
  default     = "temp-tfstate-lock"
}
