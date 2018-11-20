## print dns
output "pub" {
  value = "${aws_instance.stretch_public.*.public_dns}"
}
## print dns
output "privOFpub" {
  value = "${aws_instance.stretch_public.*.private_ip}"
}
## print dns
output "priv" {
  value = "${aws_instance.stretch_private.*.private_ip}"
}
