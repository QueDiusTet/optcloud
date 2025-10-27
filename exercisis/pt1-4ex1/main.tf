
#CONFIGURACIÓ DE TERRAFORM I AWS#
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"   # Proveïdor AWS
      version = "~> 5.0"          # Versió 5.x
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Regió on es desplegaran els recursos
}

#VPC#
resource "aws_vpc" "vpc_03" {
  cidr_block           = "10.0.0.0/16"  # Rang d’adreces IP
  enable_dns_hostnames = true           # Habilita noms DNS
  enable_dns_support   = true           # Habilita resolució DNS

  tags = {
    Name = "VPC-03"
  }
}

#INTERNET GATEWAY#
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_03.id

  tags = {
    Name = "IGW-VPC-03"
  }
}

#SUBXARXES PÚBLIQUES#
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.vpc_03.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-A"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.vpc_03.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-B"
  }
}

#TAULA DE RUTES#
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_03.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-Route-Table"
  }
}

resource "aws_route_table_association" "public_rt_assoc_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_rt.id
}

#GRUP DE SEGURETAT#
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Grup de seguretat per a instancies EC2"
  vpc_id      = aws_vpc.vpc_03.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acces SSH obert"
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "ICMP dins la VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Permet tot el trafic sortint"
  }

  tags = {
    Name = "EC2-Security-Group"
  }
}


#INSTÀNCIES EC2#
resource "aws_instance" "ec2_a" {
  ami                    = "ami-0c02fb55956c7d316"  # Amazon Linux 2023
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnet_a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = "vockey"

  tags = {
    Name = "ec2-a"
  }
}

resource "aws_instance" "ec2_b" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnet_b.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = "vockey"

  tags = {
    Name = "ec2-b"
  }
}

