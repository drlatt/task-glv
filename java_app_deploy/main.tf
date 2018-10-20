# resource "aws_elb" "load-balancer" {
#   name = "load-balancer"

#   listener {
#     lb_port = 80
#     instance_port = 80

#     lb_protocol = "http"
#     instance_protocol = "http"
#   }

#   instances = ["${aws_instance.web.*.id}"]
# }

# resource "aws_instance" "web" {

#     name = "web${count.index + 1}" #yields web1, web2
#     count = 2

#     ami             = "${lookup(var.amis, var.aws_region)}"
#     instance_type   = "t2.micro"
#     subnet_id       = "${var.aws_subnet_id}"
#     key_name        = "${var.key_name}"
#     security_groups = "${var.sec_group}"
# }