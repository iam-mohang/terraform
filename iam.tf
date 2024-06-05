data "aws_iam_policy_document" "eks_lb_controller_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com", "ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_lb_controller" {
  name               = "eks_lb_controller"
  assume_role_policy = data.aws_iam_policy_document.eks_lb_controller_assume_role.json
}

resource "aws_iam_role_policy_attachment" "eks_lb_controller_attach" {
  role       = aws_iam_role.eks_lb_controller.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/AWSLoadBalancerControllerIAMPolicy"
}

data "aws_caller_identity" "current" {}
