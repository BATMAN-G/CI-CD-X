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
  name        = "bastion-sg"
  vpc_id      = module.vpc.vpc_id
  description = "Allow SSH from Jenkins"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # ضع IP جينكينز هنا
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "nexus_sg" {
  name        = "nexus-sg"
  vpc_id      = module.vpc.vpc_id
  description = "Allow traffic only from Bastion"

  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    description = "Nexus UI internal only"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
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
  ami                         = "ami-04b70fa74e45c3917" # Ubuntu 22.04
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
# Nexus EC2 (Private)
# =======================

resource "aws_instance" "nexus" {
  ami                    = "ami-04b70fa74e45c3917"
  instance_type          = "c7i-flex.large"
  subnet_id              = module.vpc.private_subnet_ids[0]

  key_name               = "b1"
  vpc_security_group_ids = [aws_security_group.nexus_sg.id]

  tags = {
    Name = "nexus-server"
  }
}


