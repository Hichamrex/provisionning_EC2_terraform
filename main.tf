provider "aws" {
  region = "eu-west-3"
}

variable vpc_cidr_block {}
variable subnet_cidr_bock {}
variable avail_zone {}
variable env_prefix {}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cdr_block
  tags = {
    Name: "${vars.env-prefix}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_bock
  availability_zone = var.avail_zone
  tags = {
    Name: "${vars.env-prefix}-subnet-1"
  }
}


resource "aws_route_table" "myapp-rtb" {
  vpc_id = aws_vpc.myapp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name: "${var.env_prefix}-rtb"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name: "${var.env_prefix}-igw"
  }
}

resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-rtb.id
}

#####################################################
# variable "subnet_cidr_block" {
#   description = "subnet cidr block"
#   # default = "10.0.10.0/20"
#   type = list(string)
# }

# variable "environment" {
#   description = "deployment environment"
# }
 
# resource "aws_vpc" "development-vpc" {
#   cidr_block = "10.0.0.0/16"
#   tags = {
#     Name: var.environment
#   }
# }

# resource "aws_subnet" "dev-subnet-1" {
#   vpc_id = aws_vpc.development-vpc.id
#   cidr_block = var.subnet_cidr_block
#   availability_zone = "eu-west-3a"
#   tags = {
#     Name: "subnet-1-dev"
#     vpc_env: "dev"
#   }
# }

# output "dev-vpc-id" {
#   value = aws_vpc.development-vpc.id
# }

# data "aws_vpc" "existing_vpc" {
#   default = true
# }

# resource "aws_subnet" "dev-subnet-2" {
#   vpc_id = data.aws_vpc.existing_vpc.id
#   cidr_block = "172.31.48.0/20"
#   availability_zone = "eu-west-3a"
#   tags = {
#     Name: "subnet-2-default"
#   }
# }
