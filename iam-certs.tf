#uploading self cert,key to IAM
resource "aws_iam_server_certificate" "tf_cert" {
  name_prefix      = "example-cert"
  certificate_body = "${file("${var.crt_file}")}"
  private_key      = "${file("${var.key_file}")}"

  lifecycle {
    create_before_destroy = true
  }
}