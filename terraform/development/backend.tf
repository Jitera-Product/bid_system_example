terraform {
  backend "s3" {
    bucket                  = "<<PLACEHOLDER>>"
    key                     = "bid-system-development/terraform.tfstate"
    region                  = "ap-northeast-1"
  }
}
