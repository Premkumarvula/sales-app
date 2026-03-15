resource "aws_ecs_cluster" "sales_cluster" {
  name = "sales-app-cluster"
}

# Task Role - allows app to call DynamoDB
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-dynamodb-role1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "dynamodb_access" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

# Reference your existing execution role
data "aws_iam_role" "ecs_execution_role" {
  name = "sales-app-ecs-execution-role"
}