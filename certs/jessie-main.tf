resource "aws_instance" "jessie" {
  ami             = "${var.aws_amis_jessie}"
  instance_type   = "t2.micro"
  key_name        = "${var.key_name}"
  security_groups = ["tf-icmp-http-ssh"]
}
