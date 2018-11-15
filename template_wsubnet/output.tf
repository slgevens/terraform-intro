## print dns
output "public" {
  value = "${aws_instance.stretch_public.*.public_dns}"
}
## print dns
output "private" {
  value = "${aws_instance.stretch_private.*.private_ip}"
}
