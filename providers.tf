data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

variable "aws_region" {
  default = "eu-central-1"
}

provider "aws" {
  region = "${var.aws_region}"
}