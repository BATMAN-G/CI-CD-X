output "vpc_id" {
  description = "VPC ID"
  value = module.vpc.vpc_id
}


output "cluster_name" {
  description = "EKS cluster name"
  value = module.eks.cluster_name
}


output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value = module.eks.cluster_endpoint
}
output "nexus_public_ip" {
  value = aws_instance.nexus_ec2.public_ip
}

