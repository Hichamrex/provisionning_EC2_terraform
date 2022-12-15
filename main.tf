provider "aws" {
  region = "eu-west-3"
}


#create resources vpc
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cdr_block
  tags = {
    Name: "${vars.env-prefix}-vpc"
  }
}

#creating the subnet
module "my-subnet" {
  source = "./modules/subnet" 
  subnet_cidr_bock = var.subnet_cidr_bock
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.myapp-vpc 
}

module "server" {
  source = "./modules/webserver"
  vpc_id = aws_vpc.myapp-vpc.id
  my_ip = var.my_ip
  image_name = var.image_name
  public_key_location = var.public_key_location
  instance_type = var.instance_type
  subnet_id = module.my-subnet.subnet.id
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
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
