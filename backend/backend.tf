terraform {
  backend "s3" {
    bucket         = "travisterraformtest-195499643157-eu-central-1"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "travisterraformtest-195499643157-eu-central-1"
  }
}
