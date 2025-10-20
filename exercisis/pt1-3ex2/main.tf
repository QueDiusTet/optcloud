# main.tf 
provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "vpc_prinsipal" {
    cidr_block  = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "LLUK-VPC"
    }
}
resource "aws_subnet" "subnetA" {
  vpc_id = aws_vpc.vpc_prinsipal.id
  cidr_block = "10.0.32.0/25"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "SubnetA"
  }
}
resource "aws_subnet" "subnetB" {
  vpc_id = aws_vpc.vpc_prinsipal.id
  cidr_block = "10.0.30.0/23"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "SubnetB"
  }
}
resource "aws_subnet" "subnetC" {
  vpc_id = aws_vpc.vpc_prinsipal.id
  cidr_block = "10.0.33.0/28"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "SubnetC"
  }
}
# Subnet A
resource "aws_instance" "maquinas_subnetA" {
  count = 2
  ami = "ami-052064a798f08f0d3"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.subnetA.id
  tags = {
 
    Name = "SubnetA-Instance-${count.index + 1}"
  }
}
# Subnet B
resource "aws_instance" "maquinas_subnetB" {
  count = 2
  ami = "ami-052064a798f08f0d3"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.subnetB.id
  tags = {
 
    Name = "SubnetB-Instance-${count.index + 1}"
  }
}
# Subnet C
resource "aws_instance" "maquinas_subnetC" {
  count = 2
  ami = "ami-052064a798f08f0d3"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.subnetC.id
  tags = {

    Name = "SubnetC-Instance-${count.index + 1}"
  }
}
