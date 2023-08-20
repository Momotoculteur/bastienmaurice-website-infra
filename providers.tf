terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.13.1"
    }
  }

  backend "s3" {
    bucket = "bastienmaurice-website-infra-state"
    key    = "terraform/state/terraform.tfstate"
    region = "eu-west-3"

    dynamodb_table = "bastienmaurice-website-infra-state"
    encrypt        = true
  }

}

provider "aws" {
  region = "eu-west-3"
}

provider "aws" {
  alias = "acm_provider"
  region = "us-east-1"
}
