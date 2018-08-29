## print dns
output "address_stretch" {
  value = "${ aws_instance.stretch.*.public_dns}"
}

## print vpc
output "k8s_vpc" {
  value = "${ aws_vpc.tf_k8s_vpc.id }"
}
