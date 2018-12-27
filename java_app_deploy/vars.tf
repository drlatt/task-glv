# terraform variables

# aws_access_key and aws_secret_key have their values stored in the terraform.tfvars file
# you should create your own terraform.tfvars file to store these values
variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
  default = "eu-west-1"
}


variable "amis" {
  type = "map"

  default = {
    us-east-1 = "ami-0735ea082a1534cac"
    us-west-2 = "ami-01e0cf6e025c036e4"
    eu-west-1 = "ami-00b36349b3dba2ec3"
  }
}

variable "key_name" {
  default = "lat_aws"
}


variable "ssh_key_file" {
  default = ""
}
