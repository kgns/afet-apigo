locals {
  service_name = "go-api"
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_availability_zone" "az" {
  count = length(data.aws_availability_zones.available.names)
  name  = data.aws_availability_zones.available.names[count.index]
}

data "aws_service_discovery_dns_namespace" "sd" {
  name = "afet.local"
  type = "DNS_PRIVATE"
}

data "aws_ecs_cluster" "cluster" {
  cluster_name = "afet"
}

data "aws_vpc" "selected" {
  tags = {
    Name = "afet"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:Name"
    values = [for az in data.aws_availability_zone.az : "private-${az.name_suffix}"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:Name"
    values = [for az in data.aws_availability_zone.az : "public-${az.name_suffix}"]
  }
}

data "aws_wafv2_web_acl" "generic" {
  name  = "waf-generic"
  scope = "REGIONAL"
}
