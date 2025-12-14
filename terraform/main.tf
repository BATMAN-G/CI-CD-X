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
############################################
#        Nexus + Bastion HARD-CODED
############################################

# =======================
# Security Groups
# =======================


resource "aws_security_group" "bastion_sg" {
  name        = bastion_sg"
  vpc_id      = module.vpc.vpc_id
  description = "Allow traffic only from Bastion"

  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Nexus UI internal only"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 # Port 5000
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# =======================
# Bastion EC2 (Public)
# =======================

resource "aws_instance" "bastion" {
  ami                         = "ami-03c1f788292172a4e" # Ubuntu 22.04
  instance_type               = "t3.micro"
  subnet_id                   = module.vpc.public_subnet_ids[0]
  associate_public_ip_address = true

  key_name               = "b2"  # دخّل اسم مفتاحك
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "bastion-host"
  }
}

# =======================



