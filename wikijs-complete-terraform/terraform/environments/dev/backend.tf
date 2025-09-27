terraform {
  backend "s3" {
    bucket         = "terraform-state-wikijs-543518525624"
    key            = "wikijs/dev/terraform.tfstate"
    region         = "il-central-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
