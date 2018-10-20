# create AWS VPC
resource "aws_vpc" "main_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags {
    Name = "main_vpc"
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  tags {
    Name = "main_gw"
  }
}

# create subnets
resource "aws_subnet" "subnet-1" {
  vpc_id     = "${aws_vpc.main_vpc.id}"
  cidr_block = "10.0.1.0/24"

  tags {
    Name = "subnet-1"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id     = "${aws_vpc.main_vpc.id}"
  cidr_block = "10.0.2.0/24"

  tags {
    Name = "subnet-2"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = "${aws_vpc.main_vpc.default_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}