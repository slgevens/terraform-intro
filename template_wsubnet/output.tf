## print dns
output "str" {
  value = "${aws_instance.stretch.*.public_dns}"
}
