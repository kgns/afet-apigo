######## RDS
resource "aws_secretsmanager_secret" "rds" {
  name = "/service/${local.service_name}/db"
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id
  secret_string = jsonencode({
    DB_HOST : aws_rds_cluster.this.endpoint
    DB_PORT : aws_rds_cluster.this.port
    DB_USER : aws_rds_cluster.this.master_username
    DB_PASS : aws_rds_cluster.this.master_password
  })
}

######## API Key
resource "aws_secretsmanager_secret" "api_key" {
  name = "/service/${local.service_name}/api-key"
}

resource "aws_secretsmanager_secret_version" "api_key" {
  secret_id     = aws_secretsmanager_secret.api_key.id
  secret_string = var.api_key
}

######## Redis
resource "aws_secretsmanager_secret" "redis" {
  name = "/service/${local.service_name}/redis"
}

resource "aws_secretsmanager_secret_version" "redis" {
  secret_id     = aws_secretsmanager_secret.redis.id
  secret_string = var.redis_endpoint
}

######## Elastic
resource "aws_secretsmanager_secret" "elastic" {
  name = "/service/${local.service_name}/elastic"
}

resource "aws_secretsmanager_secret_version" "elastic" {
  secret_id     = aws_secretsmanager_secret.elastic.id
  secret_string = var.elastic_endpoint
}

######## Kafka
resource "aws_secretsmanager_secret" "kafka_brokers" {
  name = "/service/${local.service_name}/kafka-brokers"
}

resource "aws_secretsmanager_secret_version" "kafka_brokers" {
  secret_id     = aws_secretsmanager_secret.kafka_brokers.id
  secret_string = var.kafka_brokers
}

######## Intent Resolver API
resource "aws_secretsmanager_secret" "intent_resolver_api" {
  name = "/service/${local.service_name}/intent-resolver-api"
}

resource "aws_secretsmanager_secret_version" "intent_resolver_api" {
  secret_id = aws_secretsmanager_secret.intent_resolver_api.id
  secret_string = jsonencode({
    URL : var.intent_resolver_api_url
    KEY : var.intent_resolver_api_key
  })
}

######## Needs Resolver API
resource "aws_secretsmanager_secret" "needs_resolver_api" {
  name = "/service/${local.service_name}/needs-resolver-api"
}

resource "aws_secretsmanager_secret_version" "needs_resolver_api" {
  secret_id = aws_secretsmanager_secret.needs_resolver_api.id
  secret_string = jsonencode({
    URL : var.needs_resolver_api_url
    KEY : var.needs_resolver_api_key
  })
}
