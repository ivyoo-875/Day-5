provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "vpc1" {
    cidr_block ="10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
    vpc_id = aws_vpc.vpc1.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc1.id
}

resource "aws_route_table" "route_table" {
    vpc_id = aws_vpc.vpc1.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gateway.id
    }
}

resource "aws_route_table_association" "association" {
    route_table_id=aws_route_table.route_table.id
    subnet_id= aws_subnet.subnet.id
}

resource "aws_security_group" "web_sg" {

  name = "web-sg"
    vpc_id = aws_vpc.vpc1.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-key"
  public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
}

resource "aws_instance" "ec2" {
  ami                    = var.ami_value
  instance_type          = var.instance_type_value
  subnet_id              = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

    associate_public_ip_address = true

  key_name = aws_key_pair.terraform_key.key_name

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(pathexpand("~/.ssh/id_rsa"))
    host        = self.public_ip
  }

 provisioner "file" {
  source      = "${path.root}/app.py"
  destination = "/home/ubuntu/app.py"
}

provisioner "remote-exec" {
  inline = [
    "sudo nohup python3 /home/ubuntu/app.py > /home/ubuntu/app.log 2>&1 &"
  ]
}
}