resource "aws_instance" "webserver" {
  count                       = "${var.webserver_count}"
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${aws_key_pair.keypair.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.webserver.id}"]
  #subnet_id                   = "${element(var.subnet_id, count.index)}"
  subnet_id                   = "${element(aws_subnet.public.*.id, count.index)}"
  associate_public_ip_address = true

  connection {
    user        = "ubuntu"
    private_key = "${file("${path.root}/keys/${var.tag_project}.pem")}"
  }


  provisioner "file" {
    source      = "${path.module}/scripts/bootstrap.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]
  }

  provisioner "file" {
    source      = "chef/chef"
    destination = "/var/tmp/chef"
  }

  provisioner "file" {
    source      = "chef/cookbooks"
    destination = "/var/tmp/cookbooks"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /var/tmp/chef/client.rb /etc/chef/client.rb",
      "cd /var/tmp",
      "sudo chef-client -z -r my-cookbook::default -c /etc/chef/client.rb",
    ]
  }
}

resource "aws_elb_attachment" "webserver-elb" {
  count                       = "${var.webserver_count}"
  elb                         = "${aws_elb.webserver-elb.id}"
  instance                    = "${element(aws_instance.webserver.*.id, count.index)}"
}

resource "aws_security_group" "webserver" {
  name = "webserver"
  description                 = "webserver security group"
  vpc_id                      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb" {
    name          = "webserver-elb"
    description   = "HTTP and HTTPS from anywhere"
    vpc_id        = "${aws_vpc.vpc.id}"


    ingress {
        from_port = "80"
        to_port = "80"
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
    }

    ingress {
        from_port = "443"
        to_port = "443"
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
    }
}

resource "aws_elb" "webserver-elb" {
  name    = "webserver-elb"
  #subnets = "${var.subnet_id}"
  subnets = ["${aws_subnet.public.*.id}"]
  security_groups = ["${aws_security_group.elb.id}"]


  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  #instances                   = ["${aws_instance.webserver.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}
