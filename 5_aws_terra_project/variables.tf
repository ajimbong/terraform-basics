variable "vpc-cidr" {
  default = "10.0.0.0/16"
  type    = string
}

variable "pub-sn1" {
  default = {
    cidr = "10.0.1.0/24"
    az   = "us-east-1a"
  }
  type = object({
    cidr = string
    az   = string
  })
}

variable "pub-sn2" {
  default = {
    cidr = "10.0.2.0/24"
    az   = "us-east-1b"
  }
  type = object({
    cidr = string
    az   = string
  })
}

variable "prv-sn1" {
  default = {
    cidr = "10.0.3.0/24"
    az   = "us-east-1a"
  }
  type = object({
    cidr = string
    az   = string
  })
}

variable "prv-sn2" {
  default = {
    cidr = "10.0.4.0/24"
    az   = "us-east-1b"
  }
  type = object({
    cidr = string
    az   = string
  })
}


variable "ec2-ami" {
  #default = "ami-2023.1.20230705"
  #default = "ami-06ca3ca175f37dd66"
  default = "ami-06ca3ca175f37dd66"
  type    = string
}

variable "ec2-instance-type" {
  #default = "ami-2023.1.20230705"
  default = "t2.micro"
  type    = string
}

# required
variable "ec2-keypair" {
  default = "vpc-keypair"
  type    = string
}

variable "ec2-azs" {
  default = ["us-east-1a", "us-east-1b"]
  type    = list(string)
}
