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

############################
# ECR Repository
############################

resource "aws_ecr_repository" "app" {
  name = "my-app"

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"

  tags = {
    Name = "my-app-ecr"
  }
}

output "ecr_repo_url" {
  value = aws_ecr_repository.app.repository_url
}

############################
# IAM Role for Jenkins EC2
############################

resource "aws_iam_role" "jenkins_role" {
  name = "jenkins-terraform-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

############################
# Jenkins Policy (Terraform + ECR + EKS)
############################

resource "aws_iam_policy" "jenkins_policy" {
  name = "jenkins-terraform-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # Terraform (VPC, EKS, IAM, etc.)
      {
        Effect = "Allow"
        Action = [
          "ec2:*",
          "iam:*",
          "eks:*",
          "ecr:*",
          "elasticloadbalancing:*",
          "autoscaling:*",
          "logs:*",
          "cloudwatch:*"
        ]
        Resource = "*"
      },

      # Required for kubectl / aws cli
      {
        Effect = "Allow"
        Action = [
          "sts:GetCallerIdentity"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_attach" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = aws_iam_policy.jenkins_policy.arn
}

############################
# Instance Profile
############################

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins-profile"
  role = aws_iam_role.jenkins_role.name
}




