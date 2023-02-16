data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

########### task execution role

resource "aws_iam_role" "task_execution" {
  name               = "${local.service_name}-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "secret_policy_doc" {
  statement {
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = [
      aws_secretsmanager_secret.rds.arn
    ]
  }
}

resource "aws_iam_role_policy" "secrets" {
  name   = "secrets"
  role   = aws_iam_role.task_execution.id
  policy = data.aws_iam_policy_document.secret_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "ecr_execution" {
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "cw_logs_execution" {
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/AWSOpsWorksCloudWatchLogs"
}

########### task role

resource "aws_iam_role" "task" {
  name               = "${local.service_name}-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy" "ecs_exec" {
  name = "ecs-exec"
}

resource "aws_iam_role_policy_attachment" "ecs_exec" {
  role       = aws_iam_role.task.name
  policy_arn = data.aws_iam_policy.ecs_exec.arn
}
