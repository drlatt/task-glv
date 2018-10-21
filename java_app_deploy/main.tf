resource "aws_elb" "javaapp" {
  name                      = "javaapp"
#   availability_zones        = ["eu-west-1"]
  cross_zone_load_balancing = true
  subnets = ["${aws_subnet.subnet-1.id}", "${aws_subnet.subnet-2.id}"]
  security_groups = ["${aws_security_group.secgroup-elb.id}"]

  listener {
    instance_port      = 8080
    instance_protocol  = "http"
    lb_port = 80
    lb_protocol = "http"
    # lb_port            = 443
    # lb_protocol        = "https"
    # ssl_certificate_id = "${aws_iam_server_certificate.test_cert.arn}"
  }

  health_check = [
    {
      target              = "HTTP:8080/"
      interval            = 30
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 5
    },
  ]

#   instances = ["${aws_instance.web.*.id}"]

  tags = {
      Name = "javaapp"
  }
}



# resource "aws_instance" "web" {

#     name = "web${count.index + 1}" #yields web1, web2
#     count = 2

#     ami             = "${lookup(var.amis, var.aws_region)}"
#     instance_type   = "t2.micro"
#     subnet_id       = "${var.aws_subnet_id}"
#     key_name        = "${var.key_name}"
#     security_groups = "${var.sec_group}"
# }