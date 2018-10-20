# terraform variables

# aws_access_key and aws_secret_key have their values stored in the terraform.tfvars file
# you should create your own terraform.tfvars file to store these values
variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
  default = "eu-west-1"
}

variable "aws_subnet_id" {
  default = "subnet-da9b2abc"
}

variable "amis" {
  type = "map"

  default = {
    us-east-1 = "ami-062c7aabe0926d9cf"
    us-west-2 = "ami-0149a1175a368846c"
    eu-west-1 = "ami-045a58975c6b7ef82"
  }
}

variable "key_name" {
  default = "lat_aws"
}

variable "sec_group" {
  type    = "list"
  default = ["sg-5fa3ce22"]
}

variable "ssh_key_file" {
  default = ""
}
