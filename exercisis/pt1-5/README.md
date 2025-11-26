Pràctica Pt1.5 - Cloud Computing amb Terraform
Amb aquesta pràctica crearem una infraestructura bàsica AWS:

Una VPC amb subxarxes públiques i privades
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Subnets públiques
resource "aws_subnet" "public" {
  count             = var.subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${var.project_name}-public-${count.index + 1}"
  }
}

# Subnets privades
resource "aws_subnet" "private" {
  count             = var.subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + var.subnet_count)
  availability_zone = element(data.aws_availability_zones.available.names, count.index + 1)

  tags = {
    Name = "${var.project_name}-private-${count.index + 1}"
  }
}
Instàncies EC2 en cada tipus de subnet
# Instàncies públiques
resource "aws_instance" "public_instances" {
  count         = var.instance_count
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = element(aws_subnet.public[*].id, count.index)
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "${var.project_name}-public-${count.index + 1}"
  }
}

# Instàncies privades
resource "aws_instance" "private_instances" {
  count         = var.instance_count
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = element(aws_subnet.private[*].id, count.index)
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "${var.project_name}-private-${count.index + 1}"
  }
}
Un Internet Gateway
# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}
Un Security Group amb regles per HTTP i SSH
# Security Group
resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id
  name   = "${var.project_name}-sg"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}
Un bucket S3 condicional
# Bucket S3 condicional
resource "aws_s3_bucket" "bucket" {
  count  = var.create_s3_bucket ? 1 : 0
  bucket = "${var.project_name}-bucket-${random_id.suffix.hex}"

  tags = {
    Name = "${var.project_name}-bucket"
  }
}
Passos
Configura AWS CLI (aws configure)
Executa:
terraform init
terraform plan
terraform apply