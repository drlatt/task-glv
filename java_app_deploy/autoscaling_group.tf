resource "aws_autoscaling_group" "main-autoscaling" {
    name = "main-autoscaling"
    vpc_zone_identifier = ["${aws_subnet.subnet-1.id}", "${aws_subnet.subnet-2.id}"]
    launch_configuration = "${aws_launch_configuration.main-launchconfig.name}"
    min_size = 2
    max_size = 4
    health_check_grace_period = 300
    health_check_type = "EC2"
    force_delete = true

    tag {
        key = "Name"
        value = "java-instance"
        propagate_at_launch = true
    }
}

# create launch configuration for ec2 instances
resource "aws_launch_configuration" "main-launchconfig" {

    name_prefix = "main-launchconfig"
    image_id = "${lookup(var.amis, var.aws_region)}"
    instance_type = "t2.micro"
    key_name = "${var.key_name}"
    security_groups = ["${aws_security_group.secgroup-ssh.id}", "${aws_security_group.secgroup-app.id}"]
}

# Attach ELB to autoscaling group
resource "aws_autoscaling_attachment" "asg_attachment_main" {
  autoscaling_group_name = "${aws_autoscaling_group.main-autoscaling.id}"
  elb                    = "${aws_elb.javaapp.id}"
}


