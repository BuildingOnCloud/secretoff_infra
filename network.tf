# Default vpc
resource "aws_vpc" "secret_off_vpc" {
  name       = "secret_off_vpc1"
  cidr_block = "10.32.0.0/16"
}

# Subnets
resource "aws_subnet" "public" {
  count                   = 2
  cidr_block              = cidrsubnet(aws_vpc.secret_off_vpc.cidr_block, 8, 2 + count.index)
  vpc_id                  = aws_vpc.secret_off_vpc.id
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count             = 2
  cidr_block        = cidrsubnet(aws_vpc.secret_off_vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id            = aws_vpc.secret_off_vpc.id
}
