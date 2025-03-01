# Create the VPC 
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true // expose DNS instead of an IP address

  tags = merge(
    local.tags,
    {
      Name        = "main-vpc"
      Environment = var.environment
    }
  )
}

// Create the internet gateway
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(
    local.tags,
    {
      Name        = "internet-gateway"
      Environment = var.environment
    }
  )
}

// Attach the internet gateway
resource "aws_internet_gateway_attachment" "internet_gateway_attach" {
  internet_gateway_id = aws_internet_gateway.vpc_igw.id
  vpc_id              = aws_vpc.main_vpc.id
}


// Create the EIP for the Nat Gateway
resource "aws_eip" "nat_gateway_eip" {
  for_each = aws_subnet.public_subnets

  domain = "vpc"

  depends_on = [aws_internet_gateway.vpc_igw]

  tags = merge(
    local.tags,
    {
      Name        = "eip-nat-gateway${each.key}"
      Environment = var.environment
    }
  )
}

// Create the Nat gateway
resource "aws_nat_gateway" "nat_gateway" {
  for_each = aws_subnet.public_subnets

  allocation_id = aws_eip.nat_gateway_eip[each.key].id
   subnet_id     = each.value.id # nat should be in public subnet

  depends_on = [aws_subnet.public_subnets]

  tags = merge(
    local.tags,
    {
      Name        = "nat-gateway-${each.key}"
      Environment = var.environment
    }
  )
}

# Create route tables for public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"                     # all IP addresses
    gateway_id = aws_internet_gateway.vpc_igw.id # IPs addresses routed over the IGW
  }

  depends_on = [aws_internet_gateway.vpc_igw]

  tags = merge(
    local.tags,
    {
      Name        = "public-rtb"
      Environment = var.environment
    }
  )
}

# Create the route table for private subnets
resource "aws_route_table" "private_route_table" {
  for_each = aws_subnet.private_subnets

  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    #nat_gateway_id = aws_nat_gateway.nat_gateway.id
    nat_gateway_id = aws_nat_gateway.nat_gateway[each.key].id
  }

  tags = merge(
    local.tags,
    {
      Name        = "private-rtb-${each.key}"
      Environment = var.environment
    }
  )
}

# Create route table associations
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id

  depends_on = [aws_subnet.public_subnets]
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table[each.key].id

  depends_on = [aws_subnet.private_subnets]
}

// Create the Public Subnets
resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value + 100)
  availability_zone       = tolist(data.aws_availability_zones.available.names)[each.value]
  map_public_ip_on_launch = true

  tags = merge(
    local.tags,
    {
      Name        = each.key
      Environment = var.environment
    }
  )
}

// Create the Private Subnets
resource "aws_subnet" "private_subnets" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]

  tags = merge(
    local.tags,
    {
      Name        = each.key
      Environment = var.environment
    }
  )
}
