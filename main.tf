terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region = "eu-west-1"
}
resource "aws_vpc" "packer-test-vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true

  tags = {
    "Name" = "packer test vpc"
  }
}
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.packer-test-vpc.id
  tags = {
    "Name" : "main igw"
  }
}
resource "aws_subnet" "subnet_pub" {
  vpc_id                  = aws_vpc.packer-test-vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "packer public subnet"
  }
}
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.packer-test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "packer route-table"
  }
}
resource "aws_route_table_association" "subnet_a_association" {
  subnet_id      = aws_subnet.subnet_pub.id
  route_table_id = aws_route_table.my_route_table.id
}
resource "aws_security_group" "packer-sg" {
  name        = "packer-security-group"
  description = "packer image security group for ingress rules"
  vpc_id      = aws_vpc.packer-test-vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from any IP address
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from any IP address
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTPS from any IP address
  }

  egress {
    description      = "for all protocols"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

# resource "aws_key_pair" "example_key_pair" {
#   key_name   = "jenkins-key-pair"
#   public_key = file("~/.ssh/id_rsa.pub")  # Replace with the path to your public key file
# }

resource "aws_instance" "ubuntu" {
  ami           = "ami-036a958344c904ec4" 
  instance_type = "t2.micro"

  subnet_id       = "subnet-0d8ccdbdec9e324b4"
  security_groups = ["sg-0824d38535f914367"]

#  key_name      = aws_key_pair.example_key_pair.key_name

  tags = {
    "Name" = "ubuntu-jenkins01"
  }
}

