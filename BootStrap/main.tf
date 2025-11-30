provider "aws" {
  region = "us-east-1"
}

# -------------------------------
# Remote Backend Setup
# -------------------------------
resource "aws_s3_bucket" "state-bucket" {
  bucket = "statefile-bucket-2210xz"
  tags = {
    Name = "state-buckethawarey"
  }
}

resource "aws_dynamodb_table" "statefile-table" {
  name         = "statefile-table"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# -------------------------------
# 1️⃣ VPC (Bootstrap VPC)
# -------------------------------
resource "aws_vpc" "bootstrap_vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "bootstrap-vpc"
  }
}

# -------------------------------
# 2️⃣ Public Subnet
# -------------------------------
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.bootstrap_vpc.id
  cidr_block              = "10.10.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "bootstrap-public-subnet"
  }
}

# -------------------------------
# 3️⃣ Internet Gateway
# -------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.bootstrap_vpc.id

  tags = {
    Name = "bootstrap-igw"
  }
}

# -------------------------------
# 4️⃣ Route Table
# -------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.bootstrap_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "bootstrap-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# -------------------------------
# 5️⃣ Security Group for Jenkins EC2
# -------------------------------
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow SSH and HTTP for Jenkins"
  vpc_id      = aws_vpc.bootstrap_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins Web Interface"
    from_port   = 8080
    to_port     = 8080
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
    Name = "jenkins-sg"
  }
}

# -------------------------------
# 6️⃣ EC2 Instance for Jenkins
# -------------------------------
resource "aws_instance" "jenkins_ec2" {
  ami                         = "ami-0e001c9271cf7f3b9" 
  instance_type               = "t3.small"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true
  key_name                    = "depii"

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install docker -y
    systemctl enable docker
    systemctl start docker

    
  EOF

  tags = {
    Name = "jenkins-ec2"
  }
}
