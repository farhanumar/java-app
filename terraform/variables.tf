# variables.tf

variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "ec2_key_name" {
  description = "EC2 key pair name for EKS nodes"
  type        = string
  default     = "digitify.pem"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDRs"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether to enable NAT gateway"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Whether to use a single NAT gateway"
  type        = bool
  default     = true
}

variable "vpc_tags" {
  description = "Tags to apply to the VPC and subnets"
  type        = map(string)
  default     = {}
}

# EKS variables
variable "eks_cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "eks_cluster_version" {
  description = "EKS Cluster version"
  type        = string
}

variable "eks_managed_node_groups" {
  description = "Managed Node Groups configuration"
  type        = map(any)
}

variable "eks_tags" {
  description = "Tags to apply to the EKS cluster and resources"
  type        = map(string)
  default     = {}
}

variable "public_access_cidrs" {
  description = "CIDR blocks allowed to access the EKS public API endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # This allows public access from any IP (use carefully)
}

variable "cluster_endpoint_public_access" {
  description = "Enable public access to the EKS API endpoint"
  type        = bool
  default     = true
}

