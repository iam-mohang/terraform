provider "aws" {
  region = "us-east-1"  # Change to your desired region
}

# Fetch the caller identity
data "aws_caller_identity" "current" {}

# Assume role policy for EKS LB controller
data "aws_iam_policy_document" "eks_lb_controller_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com", "ec2.amazonaws.com"]
    }
  }
}

# Create IAM Role
resource "aws_iam_role" "eks_lb_controller" {
  name               = "eks_lb_controller"
  assume_role_policy = data.aws_iam_policy_document.eks_lb_controller_assume_role.json
}

# Policy document for the AWS Load Balancer Controller
data "aws_iam_policy_document" "aws_load_balancer_controller_policy" {
  statement {
    actions = [
      "elasticloadbalancing:*",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstances",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVpcs",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:AssignPrivateIpAddresses",
      "ec2:UnassignPrivateIpAddresses"
    ]
    resources = ["*"]
  }
}

# Create the policy
resource "aws_iam_policy" "aws_load_balancer_controller_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "Policy for EKS Load Balancer Controller"
  policy      = data.aws_iam_policy_document.aws_load_balancer_controller_policy.json
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "eks_lb_controller_attach" {
  role       = aws_iam_role.eks_lb_controller.name
  policy_arn = aws_iam_policy.aws_load_balancer_controller_policy.arn

  depends_on = [
    aws_iam_role.eks_lb_controller,
    aws_iam_policy.aws_load_balancer_controller_policy
  ]
}

