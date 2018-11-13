## print dns
output "address_stretch" {
  value = "${aws_instance.stretch.*.public_dns}"
}
