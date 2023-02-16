resource "aws_db_subnet_group" "this" {
  name       = local.service_name
  subnet_ids = data.aws_subnets.private.ids
}

resource "aws_rds_cluster" "this" {
  cluster_identifier      = "${local.service_name}-cluster"
  engine                  = "aurora-postgresql"
  engine_mode             = "serverless"
  availability_zones      = data.aws_availability_zones.available.names
  database_name           = "${local.service_name}-db"
  backup_retention_period = 5
  preferred_backup_window = "00:00-02:00"
  master_username         = var.db_user
  master_password         = var.db_pass
  vpc_security_group_ids  = [aws_security_group.rds.id]
  db_subnet_group_name    = aws_db_subnet_group.this.id
  deletion_protection     = true
  skip_final_snapshot     = true

  lifecycle {
    ignore_changes = [scaling_configuration]
  }
}
