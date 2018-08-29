resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
  depends_on = ["aws_vpc.tf_k8s_vpc"]
}

## vpc
resource "aws_vpc" "tf_k8s_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  instance_tenancy     = "${var.instance_tenancy}"
  enable_dns_support   = "${var.dns_support}"
  enable_dns_hostnames = "${var.dns_hostnames}"

  tags {
    Name = "tf_k8s_vpc"
  }
}

## subnet
resource "aws_subnet" "tf_k8s_subnet" {
  vpc_id     = "${aws_vpc.tf_k8s_vpc.id}"
  cidr_block = "${var.private_subnet_cidr}"
  depends_on = ["aws_vpc.tf_k8s_vpc"]
  vpc_id     = "${aws_vpc.tf_k8s_vpc.id}"

  tags {
    Name = "tf_k8s_subnet"
  }
}

# Secrity groups for HTTP server
resource "aws_security_group" "tf_k8s_sg_subnet" {
  name        = "tf_k8s_sg_subnet"
  description = "k8s_sg_subnet"
  depends_on  = ["aws_vpc.tf_k8s_vpc", "aws_subnet.tf_k8s_subnet"]
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10250
    to_port     = 10252
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1
    to_port     = 1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "tf_k8s_sg_default" {
  name        = "tf_k8s_sg_default"
  description = "k8s"
  depends_on  = ["aws_vpc.tf_k8s_vpc", "aws_subnet.tf_k8s_subnet"]

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1
    to_port     = 1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
