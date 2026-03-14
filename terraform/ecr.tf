resource "aws_ecr_repository" "sales_app" {
  name = "sales-app"

  image_scanning_configuration {
    scan_on_push = true
  }
}