terraform {
  backend "s3" {
    bucket                  = "<<PLACEHOLDER>>"
    key                     = "bid-system-production/terraform.tfstate"
    region                  = "ap-northeast-1"
  }
}
