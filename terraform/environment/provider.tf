# Configure the AWS Provider
provider "aws" {
  #shared_credentials_files = ["~/.aws/credentials"]
  region = var.AWS_REGION
}
