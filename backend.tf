terraform {
  backend "s3" {
    bucket = "aws-workshop-state-storage-qhe7"
    key = "aws-workshop.tfstate"
    region = "us-east-1"
  }
}