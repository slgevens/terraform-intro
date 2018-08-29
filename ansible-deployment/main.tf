resource "aws_instance" "ansible" {
  ami             = "${var.aws_amis_ansible}"
  instance_type   = "t2.micro"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.tf_icmp_ssh.name}"]

  connection {
    type        = "ssh"
    user        = "admin"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt-get -y install aptitude emacs",
    ]
  }
}

# print dns
output "address_ansible" {
  value = "${ aws_instance.ansible.public_dns}"
}

# resource "aws_instance" "stretch" {
#   ami             = "${var.aws_amis_stretch}"
#   instance_type   = "t2.micro"
#   key_name        = "${var.key_name}"
#   security_groups = ["tf-icmp-ssh"]
# }


# # print dns
# output "address_stretch" {
#   value = "${ aws_instance.stretch.public_dns}"
# }

