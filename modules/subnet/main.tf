#create resource for subnet 
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = var.vpc_id
  cidr_block = var.subnet_cidr_bock
  availability_zone = var.avail_zone
  tags = {
    Name: "${vars.env-prefix}-subnet-1"
  }
}

#create route table for incoming reuquest
resource "aws_route_table" "myapp-rtb" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name: "${var.env_prefix}-rtb"
  }
}

#create iternet gateway to acces to external usage
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = var.vpc_id
  tags = {
    Name: "${var.env_prefix}-igw"
  }
}

#assocate the route table with the gateway
resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-rtb.id
}