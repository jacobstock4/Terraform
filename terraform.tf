# A7 Terraform


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.55.0"
    }
  }
}




# Region

 provider "aws" { 
  profile = "default"
  region  = "us-east-1"
}




# VPC


resource "aws_vpc" "tf-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "tf-vpc"
  }
}




# subnet


resource "aws_subnet" "tf-subnet" {
  vpc_id     = aws_vpc.tf-vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "tf-subnet"
  }
}




# Security group

resource "aws_security_group" "tf-sg" {
  name   = "tf-sg"
  vpc_id = aws_vpc.tf-vpc.id

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
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "tf-sg"
  }
}





# Gateway


resource "aws_internet_gateway" "tf-ig" {
  vpc_id = aws_vpc.tf-vpc.id
  tags = {
    Name = "tf-ig"
  }
}






# Routeable

resource "aws_route_table" "tf-r" {
  vpc_id = aws_vpc.tf-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf-ig.id
  }
  tags = {
    Name = "tf-r"
  }
}







# Routeable Association

resource "aws_route_table_association" "tf-ra" {
  subnet_id      = aws_subnet.tf-subnet.id
  route_table_id = aws_route_table.tf-r.id
}






# Resources

resource "aws_key_pair" "tf-key" {
  key_name   = "tf-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3LHxxwuKIKGO14rCUMKGHzUMMDsmaJQk6zhP1H6zqPjPuDSI1dzTzVj+U+wQhGOpsoj/yoQff3j+3FFhVDvI2DZ6ZUvbeBH2kTvDVSS/F4Tn1fmOTVsu+MF0xS5CyTiOus3lqr3cLKR81eG4JSkTSKIgp2Cfu8F6nAWyr7Qt3qIJCoClwa7Ta+UtPXHbkMSQJWa1e0cjQhaeojN+993Bkwj4vkLoHVhwtCCyu2SIFMo4YF3h2/Ykz4RyyeWdHr0NZ3hxlDesIdn/045eNxV5bAwKxEMrq/qGuwa5BAHnwLFgNMC7VCjJAvdv5YTKS3xqkjtg2KpTOnlb7yV1P6Hhn jacobstock4@gmail.com"
}






# Instance Dev


resource "aws_instance" "dev" {
  ami                         = "ami-0557a15b87f6559cf"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.tf-sg.id]
  key_name                    = "tf-key"
  subnet_id                   = aws_subnet.tf-subnet.id
  associate_public_ip_address = "true"

  tags = {
    Name = "dev"
  }
  user_data = <<-EOF
    #!/bin/bash
    wget http://computing.utahtech.edu/it/3110/notes/2021/terraform/install.sh -O /tmp/install.sh
    chmod +x /tmp/install.sh
    source /tmp/install.sh
    EOF
}






# Instance Prod

resource "aws_instance" "prod" {
  ami                         = "ami-0557a15b87f6559cf"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.tf-sg.id]
  key_name                    = "tf-key"
  subnet_id                   = aws_subnet.tf-subnet.id
  associate_public_ip_address = "true"

  tags = {
    Name = "prod"
  }
  user_data = <<-EOF
    #!/bin/bash
    wget http://computing.utahtech.edu/it/3110/notes/2021/terraform/install.sh -O /tmp/install.sh
    chmod +x /tmp/install.sh
    source /tmp/install.sh
    EOF
}







# Instance Test

resource "aws_instance" "test" {
  ami                         = "ami-0557a15b87f6559cf"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.tf-sg.id]
  key_name                    = "tf-key"
  subnet_id                   = aws_subnet.tf-subnet.id
  associate_public_ip_address = "true"

  tags = {
    Name = "test"
  }
  user_data = <<-EOF
    #!/bin/bash
    wget http://computing.utahtech.edu/it/3110/notes/2021/terraform/install.sh -O /tmp/install.sh
    chmod +x /tmp/install.sh
    source /tmp/install.sh
    EOF
}





# Outputs


output "instance_ip_addr_test" {
  value = aws_instance.test.public_ip
}

output "instance_ip_addr_dev" {
  value = aws_instance.dev.public_ip
}

output "instance_ip_addr_prod" {
  value = aws_instance.prod.public_ip
}










