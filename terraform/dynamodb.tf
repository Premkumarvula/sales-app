resource "aws_dynamodb_table" "users" {
  name         = "Users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "username"

  attribute {
    name = "username"
    type = "S"
  }
}

resource "aws_dynamodb_table" "sales" {
  name         = "SalesTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "sale_id"

  attribute {
    name = "sale_id"
    type = "S"
  }
}