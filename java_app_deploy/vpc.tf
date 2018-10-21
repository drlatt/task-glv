# create AWS VPC
resource "aws_vpc" "main_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags {
    Name = "main_vpc"
  }
}

# create internet gateway
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

# add default route to routing table
resource "aws_route" "default_route" {
  route_table_id         = "${aws_vpc.main_vpc.default_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

# create security groups
resource "aws_security_group" "secgroup-app" {
  name        = "secgroup-app"
  description = "Allow access to app port"
  vpc_id = "${aws_vpc.main_vpc.id}"

  

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }

 
  egress {
      from_port = 0
      to_port = 0
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  tags {
    Name = "secgroup-app"
  }
}

resource "aws_security_group" "secgroup-ssh" {
  name        = "secgroup-ssh"
  description = "Allow ssh access to my IP"
  vpc_id = "${aws_vpc.main_vpc.id}"

  # allow my IP access to port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["41.58.250.171/32"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  tags {
    Name = "secgroup-ssh"
  }
}

# create ELB security group
resource "aws_security_group" "secgroup-elb" {
  name        = "secgroup-elb"
  description = "Allow access to port 443 on ELB"
  vpc_id = "${aws_vpc.main_vpc.id}"

  # allow my IP access to port 22
  ingress {
    from_port = 80
    to_port = 80
    # from_port   = 443
    # to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  tags {
    Name = "secgroup-elb"
  }
}