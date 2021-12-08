output "s3_bucket_id" {
  description = "S3 bucket name to save .tfstate file. Should be unique"
  value = aws_s3_bucket.s3-tfstate.id
}

output "dynamodb_table_name" {
  description = "Variable for dynamodb table"
  value = aws_dynamodb_table.aws-terraform-states-lock.name
}
