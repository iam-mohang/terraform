module "eks_cluster" {
  source                = "terraform-aws-modules/eks/aws"
  cluster_name          = "mohan_eks"
  cluster_version       = "1.21"
  vpc_id                = aws_vpc.main.id
  subnet_ids            = [aws_subnet.private1.id, aws_subnet.private2.id]
  node_groups           = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t3.medium"
    }
  }
}
