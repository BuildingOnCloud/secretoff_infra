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
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.secret_off_vpc.cidr_block, 8, 2 + count.index)
  vpc_id                  = aws_vpc.secret_off_vpc.id
  map_public_ip_on_launch = true
  tags = {
    name = "secret_off"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  count             = 2
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.secret_off_vpc.cidr_block, 8, count.index)
  vpc_id            = aws_vpc.secret_off_vpc.id
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

# Security Group
resource "aws_security_group" "lb" {
  name   = "secretoff-alb-security-group"
  vpc_id = aws_vpc.secret_off_vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "secret_off"
  }
}

## LB
resource "aws_lb" "secretoff_lb" {
  name            = "secretoff-lb"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
  tags = {
    name = "secret_off"
  }
}

resource "aws_lb_target_group" "secretoff_target_security_group" {
  name        = "secretoff-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.secret_off_vpc.id
  target_type = "ip"
  tags = {
    name = "secret_off"
  }
}

resource "aws_lb_listener" "secretoff_lb_listener" {
  load_balancer_arn = aws_lb.secretoff_lb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.secretoff_target_security_group.id
    type             = "forward"
  }
  tags = {
    name = "secret_off"
  }
}
