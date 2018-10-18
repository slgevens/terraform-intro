resource "aws_instance" "jessie_nodes" {
  ami             = "${var.aws_amis_jessie}"
  instance_type   = "t2.micro"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.tf_icmp_ssh.name}"]

  tags = {
    Name = "tf_jessie_nodes"
  }

  connection {
    type        = "ssh"
    user        = "admin"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update && sudo apt-get upgrade -y",
      "sudo apt-get -y install aptitude emacs git",
    ]
  }
}

resource "aws_instance" "stretch_nodes" {
  ami             = "${var.aws_amis_stretch}"
  instance_type   = "t2.micro"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.tf_icmp_ssh.name}"]

  tags = {
    Name = "tf_stretch_nodes"
  }

  connection {
    type        = "ssh"
    user        = "admin"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update && sudo apt-get upgrade -y",
      "sudo apt-get -y install aptitude emacs git",
    ]
  }
}
