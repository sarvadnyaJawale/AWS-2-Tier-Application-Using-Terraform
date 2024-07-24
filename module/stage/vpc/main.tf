# create vpc
# terraform aws create vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "tf-vpc"
  }
}

# create internet gateway and attach it to vpc
# terraform aws create internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = " tf-ig "
  }
}

resource "aws_subnet" "public_subnets" {
  count      = length(var.cidr_public_subnet)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.cidr_public_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)

  tags = {
    Name = "Subnet-Public : Public Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count      = length(var.cidr_private_subnet)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.cidr_private_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)

  tags = {
    Name = "Subnet-private : Private Subnet ${count.index + 1}"
  }
}

# create route table and add public route
# terraform aws create route table

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route { 
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "Route table for public subnets"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  route = []
  tags = {
    Name = "Route table for private subnets"
  }
}

# associate public subnet az1 to "public route table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public_subnet_asso" {
  count           = length(var.cidr_public_subnet)
  depends_on      = [aws_subnet.public_subnets, aws_route_table.public_route_table]
  subnet_id       = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id  = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_asso" {
  count           = length(var.cidr_public_subnet)
  depends_on      = [aws_subnet.private_subnets, aws_route_table.private_route_table]
  subnet_id       = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id  = aws_route_table.private_route_table.id
}

resource "aws_db_subnet_group" "two-tier-db-sub" {
  name       = "two-tier-db-sub"
  subnet_ids = aws_subnet.private_subnets[*].id

  tags = {
    Name = "Two-Tier DB Subnet Group"
  }
}

