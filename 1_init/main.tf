terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# resource "aws_i06ca3ca175f37dd66nstance" "ec2" {
#   ami = "ami-"
#   instance_type = "t2.micro"
#   tags = {
#     Name = "Hello Terra"
#   }
# }


# ---- Using terraform to reference other resources
# By creating a vpc and a subnet
resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.0.0.0/16"

	tags = {
  		Name = "demo-vpc"
	}
}

resource "aws_subnet" "demo-subnet-1" {
    vpc_id = aws_vpc.demo-vpc.id
    cidr_block = "10.0.1.0/24"
  
  tags = {
      Name = "demo-subnet-1"
  }
}

# Print out useful information (like ip addresses) when you you run [terraform apply]

output "subnet-cidr" {
  value = aws_subnet.demo-subnet-1.cidr_block
}