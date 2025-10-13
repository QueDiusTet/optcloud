provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "pt1-3-ex2-vpc" }
}

resource "aws_subnet" "A" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.32.0/25"
  availability_zone = "us-east-1a"
  tags = { Name = "subnet-A" }
}

resource "aws_subnet" "B" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.30.0/23"
  availability_zone = "us-east-1a"
  tags = { Name = "subnet-B" }
}

resource "aws_subnet" "C" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.33.0/28"
  availability_zone = "us-east-1a"
  tags = { Name = "subnet-C" }
}

resource "aws_instance" "A_instances" {
  count         = 2
  ami           = var.ami_id
  instance_type = "t3.micro"
  key_name      = var.key_name
  subnet_id     = aws_subnet.A.id
  tags = { Name = "A-${count.index + 1}" }
}

resource "aws_instance" "B_instances" {
  count         = 2
  ami           = var.ami_id
  instance_type = "t3.micro"
  key_name      = var.key_name
  subnet_id     = aws_subnet.B.id
  tags = { Name = "B-${count.index + 1}" }
}

resource "aws_instance" "C_instances" {
  count         = 2
  ami           = var.ami_id
  instance_type = "t3.micro"
  key_name      = var.key_name
  subnet_id     = aws_subnet.C.id
  tags = { Name = "C-${count.index + 1}" }
}
