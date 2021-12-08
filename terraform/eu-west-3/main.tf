terraform {
  backend "s3" {
    bucket         = "temp-tfstate-lock"
    key            = "terraform/eu-west-3/terraform.tfstate"
    dynamodb_table = "aws-terraform-states-lock"
    encrypt        = true
    region         = "eu-west-3"
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

#############################################
#                Instances
#############################################
resource "aws_instance" "web-server" {
  ami                     = "ami-0df7d9cc2767d161cd"  # Ubuntu 18.04
  instance_type           = "t2.micro"
  vpc_security_group_ids  = [aws_security_group.webserver.id]
  iam_instance_profile    = "CodeDeployInstanceRole"
  tags                    = { Name = "CodeDeploy_Server" }
  user_data               = file("user_data.sh")
}

#############################################
#             Security Group
#############################################
resource "aws_security_group" "webserver" {
  name               = "webserver1"

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

 ingress {
    from_port        = 1234  # We will run our application on this port
    to_port          = 1234
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
