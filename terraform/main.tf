module "vpc" {
  source = "./vpc"
  vpc_cidr = var.vpc_cidr
  availability_zones = var.availability_zones
  cluster_name = var.cluster_name
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs = var.public_subnet_cidrs
}

module "eks" {
  source = "./eks"
  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  subnets_id = module.vpc.private_subnet_ids
  vpc_id = module.vpc.vpc_id
  node_groups = var.node_groups
}
# ----------------------------------------------------
# EC2 Instance for Nexus Repository Manager (Ansible-managed)
# ----------------------------------------------------
resource "aws_instance" "nexus_ec2" {
  ami                         = "ami-0e001c9271cf7f3b9"  # Ubuntu 22.04 LTS (update if needed)
  instance_type               = "t2.medium"
  subnet_id                   = module.vpc.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.nexus_sg.id]
  associate_public_ip_address = true
  key_name                    = "jenkins-keypair"

  tags = {
    Name = "Nexus-Server"
    Role = "Nexus"
  }
}
resource "aws_security_group" "nexus_sg" {
  name        = "nexus-sg"
  description = "Allow SSH (22) and Nexus (8081) access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Nexus UI access"
    from_port   = 8081
    to_port     = 8081
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
    Name = "nexus-sg"
  }
}
