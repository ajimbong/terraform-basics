variable "vpc-cidr" {
  default = "10.0.0.0/16"
  type = string
}

variable "pub-sn1" {
  default = {
    cidr = "10.0.1.0/24"
    az = "us-east-1a"
  }
  type = object({
    cidr = string
    az = string
  })
}

variable "pub-sn2" {
  default = {
    cidr = "10.0.2.0/24"
    az = "us-east-1b"
  }
  type = object({
    cidr = string
    az = string
  })
}

variable "prv-sn1" {
  default = {
    cidr = "10.0.3.0/24"
    az = "us-east-1a"
  }
  type = object({
    cidr = string
    az = string
  })
}

variable "prv-sn2" {
  default = {
    cidr = "10.0.4.0/24"
    az = "us-east-1b"
  }
  type = object({
    cidr = string
    az = string
  })
}