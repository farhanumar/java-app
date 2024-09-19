data "aws_caller_identity" "current" {}
data "aws_iam_session_context" "current" {
  # "This data source provides information on the IAM source role of an STS assumed role. For non-role ARNs, this data source simply passes the ARN through in issuer_arn."
  arn = data.aws_caller_identity.current.arn
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.0.4"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids
  kms_key_administrators = [data.aws_iam_session_context.current.issuer_arn]
  enable_irsa = false

  cluster_endpoint_private_access = false
  cluster_endpoint_public_access = true



  # Managed Node Groups
  eks_managed_node_groups = var.eks_managed_node_groups
   
  # Enable public access to the EKS API

  tags = var.tags

}


output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_name" {
  value = module.eks.cluster_name
}

