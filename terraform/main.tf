module "vpc" {
  source = "./modules/vpc"

  name              = var.vpc_name
  cidr              = var.vpc_cidr
  azs               = var.availability_zones
  private_subnets   = var.private_subnets
  public_subnets    = var.public_subnets
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  tags              = var.vpc_tags
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
  eks_managed_node_groups = var.eks_managed_node_groups
  tags            = var.eks_tags

  # Optionally restrict public access to specific CIDR blocks (like your office or home IP range)
  public_access_cidrs = var.public_access_cidrs
}


