resource "aws_security_group" "alb" {
  name   = "${local.service_name}-alb-sg"
  vpc_id = data.aws_vpc.selected.id
}

resource "aws_security_group_rule" "alb_http" {
  description       = "Allow IPv4 HTTP traffic from outside"
  type              = "ingress"
  from_port         = aws_lb_listener.this.port
  to_port           = aws_lb_listener.this.port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group" "this" {
  name   = "${local.service_name}-task-sg"
  vpc_id = data.aws_vpc.selected.id
}

resource "aws_security_group_rule" "this_alb" {
  description              = "Allow TCP on 80 from ALB"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.this.id
}

resource "aws_security_group_rule" "this_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group" "rds" {
  name   = "${local.service_name}-rds-sg"
  vpc_id = data.aws_vpc.selected.id
}

resource "aws_security_group_rule" "rds_ecs" {
  description              = "Allow access from ${local.service_name} tasks"
  type                     = "ingress"
  from_port                = aws_rds_cluster.this.port
  to_port                  = aws_rds_cluster.this.port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.this.id
  security_group_id        = aws_security_group.rds.id
}

resource "aws_security_group_rule" "rds_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds.id
}
