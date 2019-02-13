#amazon ami id
output "image_id" {
  value = "${data.aws_ami.amazon-linux-2.id}"
}

#elb dns name
output "elb_dns_name" {
  value = "${aws_elb.tf-elb.dns_name}"
}

#elb attached instances
output "elb_instances" {
  value = "${aws_elb.tf-elb.instances}"
}
