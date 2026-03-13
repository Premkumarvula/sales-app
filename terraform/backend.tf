terraform {
  backend "s3" {
    bucket         = "sales-app-terraform-state1"
    key            = "sales-app/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}