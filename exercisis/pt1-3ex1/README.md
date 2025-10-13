Exercici 1
Creació de dues instàncies t3.micro a AWS via Terraform.

terraform

# main.tf
```
provider "aws" {
    region = "us-east-1"
}

# Creem les dues instàncies
resource "aws_instance" "ec2" {
  count         = 2
  ami           = var.ami_id
  instance_type = "t3.micro"

  tags = {
    Name = "pt1-3-ex1-instance-${count.index + 1}"
  }
}
```
Després ho apliquem amb un $terraform plan i $terraform apply

Topologia a Lucid:
![foto lucid](<assets/images/Marco vertical AWS (2019).png>)