resource "aws_instance" "jessie" {
  ami             = "${var.aws_amis_jessie}"
  instance_type   = "t2.micro"
  key_name        = "${var.key_name}"
  security_groups = ["tf-icmp-http-ssh"]
  tags = {
    Name = "jessie ESC"
  }
}

# print dns
output "address_jessie" {
  value = "${ aws_instance.jessie.public_dns}"
}
