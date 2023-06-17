terraform {
  backend "s3" {
    bucket = "bw-tf-backend-bucket-file-notifs"
    key = "terraform.tfstate"
    region = "eu-west-2"
  }
}