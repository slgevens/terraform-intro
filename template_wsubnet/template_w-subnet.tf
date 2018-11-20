resource "aws_instance" "stretch_public" {
  ami                         = "${var.aws_amis_stretch}"
  instance_type               = "t2.medium"
  key_name                    = "${var.key_name}"
  count                       = "${length(var.hostname)}"
  subnet_id                   = "${aws_subnet.tf_template_wsubnet_pub_subnet.id}"
  associate_public_ip_address = true
  private_ip                  = "${var.private_ips[count.index]}"
  source_dest_check           = false
  vpc_security_group_ids      = ["${aws_security_group.tf_template_wsubnet_sg_subnet.id}"]

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
resource "aws_instance" "stretch_private" {
  ami                         = "${var.aws_amis_stretch}"
  instance_type               = "t2.medium"
  key_name                    = "${var.key_name}"
  count                       = "${length(var.hostname_private)}"
  subnet_id                   = "${aws_subnet.tf_template_wsubnet_priv_subnet.id}"
  source_dest_check           = false
  private_ip                  = "${var.private_private_ips[count.index]}"
  vpc_security_group_ids      = ["${aws_security_group.tf_template_wsubnet_sg_default.id}"]
  depends_on                  = ["aws_nat_gateway.tf_template_wsubnet_nat_gateway"]
  tags = {
    Name = "${var.hostname_private[count.index]}"
  }

  connection {
    type        = "ssh"
    user        = "admin"
    private_key = "${file(var.private_key_path)}"
    timeout     = "1m"
    bastion_host = "${element(aws_instance.stretch_public.*.public_dns, 0)}"
    bastion_user = "admin"
    bastion_port = "22"
    bastion_private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get -y install rsync emacs aptitude",
    ]
  }
}
