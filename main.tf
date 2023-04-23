provider "aws" {
  region = "us-west-2"
}

locals {
  your_name     = "Asharib"
  secret_value  = "04/19/2023 Asharib Mazhar ExTend"
}

resource "aws_secretsmanager_secret" "interview_secret" {
  name = "extend-interview/${local.your_name}"
}

resource "aws_secretsmanager_secret_version" "interview_secret_version" {
  secret_id     = aws_secretsmanager_secret.interview_secret.id
  secret_string = local.secret_value
}

resource "aws_iam_role" "interview_bot" {
  name = "interview-bot"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "interview_developer" {
  name = "interview-developer"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "interview_bot_policy" {
  name        = "interview-bot-policy"
  description = "Policy to allow the interview-bot role to read the secret"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
        Resource = aws_secretsmanager_secret.interview_secret.arn
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "interview_bot_policy_attachment" {
  name       = "interview-bot-policy-attachment"
  roles      = [aws_iam_role.interview_bot.name]
  policy_arn = aws_iam_policy.interview_bot_policy.arn
}

