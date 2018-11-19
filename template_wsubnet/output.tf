## print dns
output "public" {
  value = "${aws_instance.stretch_public.*.public_dns}"
}
# ## print dns
# output "private of public" {
#   value = "${aws_instance.stretch_public.*.private_ip}"
# }
## print dns
output "private" {
  value = "${aws_instance.stretch_private.*.private_ip}"
}
