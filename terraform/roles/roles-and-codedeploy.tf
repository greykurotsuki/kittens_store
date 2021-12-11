terraform {
  backend "s3" {
    bucket         = "temp-tfstate-lock"
    key            = "terraform/roles/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "aws-terraform-states-lock"
    encrypt        = true
    }
}

provider "aws" {
  region                  = var.aws_region
}

################################################################
#        Create IAM roles: CodeDeployInstanceRole
################################################################

resource "aws_iam_instance_profile" "instance_profile" {
  name = "instance_profile"
  role = aws_iam_role.CodeDeployInstanceRole.name
}
resource "aws_iam_role" "CodeDeployInstanceRole" {
  name = "CodeDeployInstanceRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AmazonEC2RoleforAWSCodeDeploy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
  role       = aws_iam_role.CodeDeployInstanceRole.name
}

# Grand AutoScalingNotificationAccessRole to the CodeDeployInstanceRole
resource "aws_iam_role_policy_attachment" "AutoScalingNotificationAccessRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AutoScalingNotificationAccessRole"
  role       = aws_iam_role.CodeDeployInstanceRole.name
}

################################################################
#        Create IAM roles: CodeDeployRole
################################################################

resource "aws_iam_role" "CodeDeployServiceRole" {
  name = "CodeDeployServiceRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Grand AWSCodeDeployRole to the CodeDeployServiceRole
resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.CodeDeployServiceRole.name
}


################################################
#        Create CodeDeploy Application
################################################
resource "aws_codedeploy_app" "codedeploy-main" {
  compute_platform = "Server"
  name             = "codedeploy-main"
}

################################################
#           Create Deployment Group
################################################

resource "aws_codedeploy_deployment_group" "main" {
  app_name              = aws_codedeploy_app.codedeploy-main.name
  deployment_group_name = "main"
  service_role_arn      = aws_iam_role.CodeDeployServiceRole.arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "name"
      type  = "KEY_AND_VALUE"
      value = "CodeDeploy-main"
    }
  }

  ec2_tag_set {
    ec2_tag_filter {
      key   = "env"
      type  = "KEY_AND_VALUE"
      value = "main"
    }
  }  
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  alarm_configuration {
    alarms  = ["my-alarm-name"]
    enabled = true
  }
  
  depends_on = [
    aws_codedeploy_app.codedeploy-main,
    aws_iam_role.CodeDeployServiceRole
  ]
}
