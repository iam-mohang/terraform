module "eks_cluster" {
  source                = "terraform-aws-modules/eks/aws"
  cluster_name          = "mohan_eks"
  cluster_version       = "1.25"
  vpc_id                = aws_vpc.main.id
  subnet_ids            = [aws_subnet.private1.id, aws_subnet.private2.id]
  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    instance_types         = ["t3.medium"]
  }

  eks_managed_node_groups = {

    node_group = {
      min_size     = 2
      max_size     = 6
      desired_size = 2
    }
  }
}
