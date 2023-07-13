terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.7.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user_policy" "lb_ro" {
  name = "admin"
  user = aws_iam_user.terra_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "*"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_user" "terra_user" {
  name = "terra_user"
  tags = {
    Description = "Terraform User"
  }
}