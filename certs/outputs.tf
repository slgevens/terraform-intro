# print dns
output "address_jessie" {
  value = "${ aws_instance.jessie.public_dns}"
}

output "address_stretch" {
  value = "${ aws_instance.stretch.public_dns}"
}
