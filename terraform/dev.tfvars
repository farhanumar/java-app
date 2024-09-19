# dev.tfvars

region            = "us-west-2"
ec2_key_name      = "my-ec2-key"

# VPC Configuration
vpc_name          = "custom-eks-vpc"
vpc_cidr          = "10.0.0.0/16"
availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
private_subnets   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets    = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
enable_nat_gateway = true
single_nat_gateway = true
vpc_tags = {
  Name = "custom-vpc"
}

# EKS Configuration
eks_cluster_name    = "custom-eks-cluster"
eks_cluster_version = "1.29"
eks_managed_node_groups = {
  default = {
    desired_capacity = 3
    max_capacity     = 6
    min_capacity     = 1
    instance_type    = "t3.medium"
  }
}
eks_tags = {
  Name = "custom-eks-cluster"
}

