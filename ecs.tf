resource "aws_service_discovery_service" "this" {
  name = "${local.service_name}-svc"

  dns_config {
    namespace_id = data.aws_service_discovery_dns_namespace.sd.id

    dns_records {
      ttl  = 10
      type = "SRV"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }

  tags = {
    "METRICS_PORT" = "80"
    "METRICS_PATH" = "/metrics"
  }
}

resource "aws_ecs_service" "this" {
  name                   = "${local.service_name}-service"
  cluster                = data.aws_ecs_cluster.cluster.id
  task_definition        = aws_ecs_task_definition.this.arn
  desired_count          = var.desired_count
  launch_type            = "FARGATE"
  enable_execute_command = true

  network_configuration {
    subnets          = data.aws_subnets.private.ids
    security_groups  = [aws_security_group.this.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = local.service_name
    container_port   = 80
  }

  service_registries {
    registry_arn   = aws_service_discovery_service.this.arn
    container_name = local.service_name
    container_port = 80
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = local.service_name
  task_role_arn            = aws_iam_role.task.arn
  execution_role_arn       = aws_iam_role.task_execution.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory

  container_definitions = templatefile(
    "${path.module}/task-definition.json", {
      service_name                   = local.service_name
      image                          = "${aws_ecr_repository.this.repository_url}:${var.image_tag}"
      region                         = data.aws_region.current.name
      rds_secret_arn                 = aws_secretsmanager_secret.rds.arn
      api_key_secret_arn             = aws_secretsmanager_secret.api_key.arn
      redis_secret_arn               = aws_secretsmanager_secret.redis.arn
      elastic_secret_arn             = aws_secretsmanager_secret.elastic.arn
      kafka_brokers_secret_arn       = aws_secretsmanager_secret.kafka_brokers.arn
      intent_resolver_api_secret_arn = aws_secretsmanager_secret.intent_resolver_api.arn
      needs_resolver_api_secret_arn  = aws_secretsmanager_secret.needs_resolver_api.arn
  })

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}
