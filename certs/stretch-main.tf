resource "aws_instance" "stretch" {
  ami             = "${var.aws_amis_stretch}"
  instance_type   = "t2.micro"
  key_name        = "${var.key_name}"
  security_groups = ["tf-icmp-http-ssh"]
}
