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
    lifecycle {
        create_before_destroy = "true"
    }
    key_name = "${var.key_name}"
    security_groups = ["${aws_security_group.secgroup-ssh.id}", "${aws_security_group.secgroup-app.id}"]

    user_data = <<-LOH
                    apt-get update
                    apt-get install default-jdk -y 
                    groupadd tomcat
                    useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
                    cd /tmp
                    curl -LO https://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.34/bin/apache-tomcat-8.5.34.tar.gz
                    mkdir /opt/tomcat
                    tar xzvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1
                    cd /opt/tomcat
                    chgrp -R tomcat /opt/tomcat
                    chmod -R g+r conf
                    chmod g+x conf
                    chown -R tomcat webapps/ work/ temp/ logs/

                    cat > /etc/systemd/system/tomcat.service <<'_END'
                        [Unit]
                        Description=Apache Tomcat Web Application Container
                        After=network.target

                        [Service]
                        Type=forking

                        Environment=JAVA_HOME=/usr/lib/jvm/java-1.9.0-openjdk-amd64
                        Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
                        Environment=CATALINA_HOME=/opt/tomcat
                        Environment=CATALINA_BASE=/opt/tomcat
                        Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
                        Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

                        ExecStart=/opt/tomcat/bin/startup.sh
                        ExecStop=/opt/tomcat/bin/shutdown.sh

                        User=tomcat
                        Group=tomcat
                        UMask=0007
                        RestartSec=10
                        Restart=always

                        [Install]
                        WantedBy=multi-user.target
                    END

                    systemctl daemon-reload
                    systemctl start tomcat
                    ufw allow 8080
                    systemctl enable tomcat
        LOH
}

# Attach ELB to autoscaling group
resource "aws_autoscaling_attachment" "asg_attachment_main" {
  autoscaling_group_name = "${aws_autoscaling_group.main-autoscaling.id}"
  elb                    = "${aws_elb.javaapp.id}"
}


