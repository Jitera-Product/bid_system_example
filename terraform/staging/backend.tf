terraform {
  backend "s3" {
    bucket                  = "<<PLACEHOLDER>>"
    key                     = "bid-system-staging/terraform.tfstate"
    region                  = "ap-northeast-1"
  }
}
