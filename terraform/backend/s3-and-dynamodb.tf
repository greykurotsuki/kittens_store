terraform {
  backend "s3" {
    bucket         = "temp-tfstate-lock"
    key            = "terraform/backend/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "aws-terraform-states-lock"
    encrypt        = true
  }
  
  required_providers {
      aws = {
          version  = "~> 3.0"
      }
  }
  required_version = ">= 0.13"
}

provider "aws" {
  region                  = var.aws_region
}

# Create a s3 bucket to keep .tfstate file
resource "aws_s3_bucket" "s3-tfstate" {
  bucket = var.state_bucket
  acl    = "private"
  
  object_lock_configuration{
    object_lock_enabled = "Enabled"
  }

  versioning {
    enabled = true
  }
  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = var.state_bucket
    Environment = "Dev"
  }
}

# Create a DynamoDB table to lock tfstate file at S3 bucket
resource "aws_dynamodb_table" "aws-terraform-states-lock" {
  name           = var.dynamodb
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = var.dynamodb
  }
}

# Block any public access to our s3 bucket
resource "aws_s3_account_public_access_block" "s3_access_block" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}