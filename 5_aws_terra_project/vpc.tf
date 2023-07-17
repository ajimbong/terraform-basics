# VPC
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc-cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "Trust VPC"
  }
}


# Subnets
resource "aws_subnet" "pub-sn1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pub-sn1.cidr
  availability_zone = var.pub-sn1.az
  map_public_ip_on_launch = true

  tags = {
    Name = "Trust Pub1"
  }
}

resource "aws_subnet" "pub-sn2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pub-sn2.cidr
  availability_zone = var.pub-sn2.az
  map_public_ip_on_launch = true

  tags = {
    Name = "Trust Pub2"
  }
}

resource "aws_subnet" "prv-sn1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.prv-sn1.cidr
  availability_zone = var.prv-sn1.az
  map_public_ip_on_launch = false

  tags = {
    Name = "Trust Prv1"
  }
}

resource "aws_subnet" "prv-sn2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.prv-sn2.cidr
  availability_zone = var.prv-sn2.az
  map_public_ip_on_launch = false

  tags = {
    Name = "Trust Prv2"
  }
}


# IGW and Public Subnet RT
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Trust IGW"
  }
}

# This is not necssary
# resource "aws_internet_gateway_attachment" "igw-attachment" {
#   internet_gateway_id = aws_internet_gateway.igw.id
#   vpc_id              = aws_vpc.vpc.id
# }

resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Trust Pub RT"
  }
}

resource "aws_route_table_association" "pub-sn1-rt-assoc" {
  subnet_id      = aws_subnet.pub-sn1.id
  route_table_id = aws_route_table.pub-rt.id
}

resource "aws_route_table_association" "pub-sn2-rt-assoc" {
  subnet_id      = aws_subnet.pub-sn2.id
  route_table_id = aws_route_table.pub-rt.id
}


# NGW and Public Subnet RT
resource "aws_eip" "ngw1-eip" {
  domain   = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "ngw2-eip" {
  domain   = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "ngw1" {
  allocation_id = aws_eip.ngw1-eip.id
  subnet_id     = aws_subnet.prv-sn1.id

  tags = {
    Name = "Trust NAT1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "ngw2" {
  allocation_id = aws_eip.ngw2-eip.id
  subnet_id     = aws_subnet.prv-sn2.id

  tags = {
    Name = "Trust NAT2"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "prv-rt1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw1.id
  }

  tags = {
    Name = "Trust Priv RT1"
  }
}

resource "aws_route_table_association" "prv-sn1-rt-assoc" {
  subnet_id      = aws_subnet.prv-sn1.id
  route_table_id = aws_route_table.prv-rt1.id
}

resource "aws_route_table" "prv-rt2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw2.id
  }

  tags = {
    Name = "Trust Priv RT2"
  }
}

resource "aws_route_table_association" "prv-sn2-rt-assoc" {
  subnet_id      = aws_subnet.prv-sn2.id
  route_table_id = aws_route_table.prv-rt2.id
}