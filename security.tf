resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "all_worker_mgmt_ingress_https" {   # Renamed
  description       = "allow inbound traffic from eks"
  from_port         = 443
  protocol          = "-1"
  to_port           = 443
  security_group_id = aws_security_group.all_worker_mgmt.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "all_worker_mgmt_ingress_http" {    # Renamed
  description       = "allow inbound traffic from eks"
  from_port         = 80
  protocol          = "TCP"
  to_port           = 80
  security_group_id = aws_security_group.all_worker_mgmt.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "all_worker_mgmt_egress" {
  description       = "allow outbound traffic to anywhere"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.all_worker_mgmt.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

