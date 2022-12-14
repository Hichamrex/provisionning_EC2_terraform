#create a security group to confiure the firewall
resource "aws_security_group" "myapp-sg" {
  name = "myapp-sg"
  vpc_id = var.vpc_id
  ingress  {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #allow any traffic to leave the ec2
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name: "${var.env_prefix}-sg"
  }
}

#to get the ami id dynamicly
data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = [var.image_name]
  }
  filter {
    name = "virtualization-type"
    value = ["hvm"]
  }

}

resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"
  public_key = file(var.public_key_location)
}

resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  type = var.instance_type
  # subnet_id = aws_subnet.myapp-subnet-1.id
  subnet_id = var.subnet_id 
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]
  availability_zone = var.avail_zone
  associate_public_ip_address = true
  # key_name = "server-key-pair"
  key_name = aws_key_pair.ssh-key.key_name
  user_data = file("./entry_point.sh")
  
  # connection {
  #   type = "ssh"
  #   host = self.public_ip
  #   user = "ec2-user"
  #   private_key = file(var.private_key_location)
  # }

  # provisioner "file" {
  #   source = "entry_point.sh"
  #   destination = "/home/ec2-user/entry-point-ec2.sh"
  # }
  # provisioner "remote-exec" {
  #   # inline = [

  #   # ]
  #    script = file("entry-point-ec2.sh")
  # }

  # provisioner "local-exec" {
  #   command = "echo ${self.public_ip}"
  # }

  tags = {
    Name = "${var.env_prefix}-server" 
  }
}