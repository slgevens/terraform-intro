resource "aws_instance" "stretch" {
  ami                         = "${var.aws_amis_stretch}"
  instance_type               = "t2.medium"
  key_name                    = "${var.key_name}"
  count                       = "${length(var.hostname)}"
  subnet_id                   = "${aws_subnet.tf_template_wsubnet_pub_subnet.id}"
  associate_public_ip_address = true
  source_dest_check           = false
  vpc_security_group_ids      = ["${aws_security_group.tf_template_wsubnet_sg_subnet.id}", "${aws_security_group.tf_template_wsubnet_sg_default.id}"]

  tags = {
    Name = "${var.hostname[count.index]}"
  }

  connection {
    type        = "ssh"
    user        = "admin"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get -y install rsync emacs aptitude",
    ]
  }
}
