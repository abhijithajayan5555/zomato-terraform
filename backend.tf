terraform {
  backend "s3" {
    bucket = "zomato-statefile"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}
