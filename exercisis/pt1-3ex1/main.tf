provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2" {
  count         = 2
  ami           = var.ami_id
  instance_type = "t3.micro"

  tags = {
    Name = "pt1-3-ex1-instance-${count.index + 1}"
  }
}
