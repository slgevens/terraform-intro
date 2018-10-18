# print dns
output "address_jessie_nodes" {
  value = "${aws_instance.jessie_nodes.public_dns}"
}

# print dns
output "address_stretch_nodes" {
  value = "${aws_instance.stretch_nodes.public_dns}"
}

# # print dns
# output "address_controller" {
#   value = "${aws_instance.controller.public_dns}"
# }

