resource "aws_instance" "stretch" {
  ami             = "${var.aws_amis_stretch}"
  instance_type   = "t2.medium"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.tf_k8s_sg_subnet.name}", "${aws_security_group.tf_k8s_sg_default.name}"]
  count           = "${length(var.hostname)}"
  subnet_id       = "${aws_subnet.tf_k8s_subnet.id}"
  depends_on      = ["aws_vpc.tf_k8s_vpc", "aws_subnet.tf_k8s_subnet", "aws_security_group.tf_k8s_sg_subnet", "aws_security_group.tf_k8s_sg_default"]

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
      "sudo apt-get -y install rsync",
      "sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
      "sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -",
      "sudo apt-key fingerprint 0EBFCD88",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable\"",
      "sudo apt-get update && sudo apt-get install -y docker-ce=17.09.0~ce-0~debian",
      "sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] http://apt.kubernetes.io/ kubernetes-xenial main\"",
      "sudo apt-get update && sudo apt-get install -y --allow-unauthenticated kubelet kubeadm kubectl cri-tools ebtables kubernetes-cni socat",
      "sudo apt-mark hold kubelet kubeadm kubectl",
    ]
  }
}
