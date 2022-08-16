# Default vpc
resource "aws_vpc" "secret_off_vpc" {
  tags = {
    name = "secret_off"
  }
  cidr_block = "10.32.0.0/16"
}

# Public Subnet
resource "aws_subnet" "public" {
  count                   = 2
  cidr_block              = cidrsubnet(aws_vpc.secret_off_vpc.cidr_block, 8, 2 + count.index)
  vpc_id                  = aws_vpc.secret_off_vpc.id
  map_public_ip_on_launch = true
  tags = {
    name = "secret_off"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  count      = 2
  cidr_block = cidrsubnet(aws_vpc.secret_off_vpc.cidr_block, 8, count.index)
  vpc_id     = aws_vpc.secret_off_vpc.id
  tags = {
    name = "secret_off"
  }
}

# Internet gateway (VPC / Internet)
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.secret_off_vpc.id
  tags = {
    name = "secret_off"
  }
}

# Routing Table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.secret_off_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
  tags = {
    name = "secret_off"
  }
}

# Elastic IP (public addresses)
resource "aws_eip" "gateway" {
  count      = 2
  vpc        = true
  depends_on = [aws_internet_gateway.gateway]
  tags = {
    name = "secret_off"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "gateway" {
  count         = 2
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.gateway.*.id, count.index)
  tags = {
    name = "secret_off"
  }
}

# Routing Table
resource "aws_route_table" "private" {
  count  = 2
  vpc_id = aws_vpc.secret_off_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.gateway.*.id, count.index)
  }
  tags = {
    name = "secret_off"
  }
}

# Route Table association with subnets
resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
