terraform {
  backend "s3" {
    bucket = "bucket"
    key = "terraform.tfstate"
    region = "region"
  }
}