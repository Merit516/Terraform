#s3 bucket extend of terraform.tfstate.d
resource "aws_s3_bucket" "terraform-state-bucket" {
  bucket = "merit-terraform-state-bucket"

  #prevent  accidental delation of this  s3 bucket
  lifecycle {
    #prevent_destroy = true
  }
}
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform-state-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform_up_and_running_locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
terraform {
  backend "s3" {
    bucket         = "merit-terraform-state-bucket"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_up_and_running_locks"
    encrypt        = "true"
  }
}