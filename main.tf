#lookup for amazon linux 2 ami
data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

#attach local pub key to ec2
resource "aws_key_pair" "default" {
  key_name   = "terraform-ex"
  public_key = "${file("${var.key_path}")}"
}

#user data template
data "template_file" "boot-strap" {
  template = "${file("boot-strap.sh")}"
}

#instance launch config
resource "aws_launch_template" "ec2_launch_template" {
  name_prefix            = "foobar"
  image_id               = "${data.aws_ami.amazon-linux-2.id}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.pubsg.id}"]
  key_name               = "${aws_key_pair.default.id}"

  user_data = "${base64encode(data.template_file.boot-strap.rendered)}"

  tags {
    Name = "tf-ec2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

#auto scaling group
resource "aws_autoscaling_group" "bar" {
  name                      = "tf-autoscale-grp"
  availability_zones        = ["us-east-1a", "us-east-1b", "us-east-1c"]
  desired_capacity          = 2
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  vpc_zone_identifier       = ["${aws_subnet.my_pub_subnet.id}"]
  load_balancers            = ["${aws_elb.tf-elb.id}"]

  launch_template {
    id      = "${aws_launch_template.ec2_launch_template.id}"
    version = "$$Latest"
  }
}

# Create a new load balancer
resource "aws_elb" "tf-elb" {
  name = "terraform-elb"

  # availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  security_groups = ["${aws_security_group.elb.id}"]
  subnets         = ["${aws_subnet.my_pub_subnet.id}"]

  access_logs {
    bucket        = "elb-logs-tf"
    bucket_prefix = "elb-logs-test"
    interval      = 60
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 443
    instance_protocol  = "https"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${aws_iam_server_certificate.tf_cert.arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 3
    target              = "TCP:80"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "terraform-elb"
  }
}
