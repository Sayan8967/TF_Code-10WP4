terraform {
  backend "s3" {
    bucket = "mybucket-shaan-8967"
    key = "backend/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "mytable-shaan"    
  }
}