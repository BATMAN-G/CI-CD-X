terraform {
  backend "s3" {
    bucket="statefile-bucket-2210xz"
    key="terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "statefile-table"
  }
}
