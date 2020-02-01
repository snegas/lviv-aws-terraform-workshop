resource "random_string" "default" {
  length = 4
  special = false
  upper = false
}

resource "aws_s3_bucket" "default" {
  bucket = "aws-workshop-state-storage-${random_string.default.result}"
  acl = "private"

  versioning {
    enabled = true
  }
}