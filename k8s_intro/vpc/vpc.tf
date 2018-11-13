variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_cidr" {
  description = "CIDR for the private subnet"
  default     = "10.0.1.0/24"
}

variable "private_cidr" {
  description = "CIDR for the private subnet"
  default     = "10.0.2.0/24"
}

variable "instance_tenancy" {
  default = "default"
}

variable "dns_support" {
  default = true
}

variable "dns_hostnames" {
  default = true
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

## subnet pub & priv
resource "aws_subnet" "tf_k8s_pub_subnet" {
  vpc_id                  = "${aws_vpc.tf_k8s_vpc.id}"
  cidr_block              = "${var.public_cidr}"
  map_public_ip_on_launch = "True"
  depends_on              = ["aws_vpc.tf_k8s_vpc"]

  tags {
    Name = "tf_k8s_public_subnet"
  }
}

resource "aws_subnet" "tf_k8s_priv_subnet" {
  vpc_id     = "${aws_vpc.tf_k8s_vpc.id}"
  cidr_block = "${var.private_cidr}"

  tags {
    Name = "tf_k8s_private_subnet"
  }
}

resource "aws_internet_gateway" "tf_k8s_gw" {
  vpc_id     = "${aws_vpc.tf_k8s_vpc.id}"
  depends_on = ["aws_vpc.tf_k8s_vpc"]

  tags {
    Name = "tf_k8s_internet_gw"
  }
}

resource "aws_route_table" "tf_k8s_pub_rt" {
  vpc_id     = "${aws_vpc.tf_k8s_vpc.id}"
  depends_on = ["aws_vpc.tf_k8s_vpc"]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.tf_k8s_gw.id}"
  }

  tags {
    Name = "tf_k8s_subnet_rt"
  }
}

resource "aws_route_table_association" "tf_k8s_pub_rta" {
  subnet_id      = "${aws_subnet.tf_k8s_pub_subnet.id}"
  route_table_id = "${aws_route_table.tf_k8s_pub_rt.id}"
  depends_on     = ["aws_vpc.tf_k8s_vpc"]
}

# Secrity groups for HTTP server
resource "aws_security_group" "tf_k8s_sg_subnet" {
  name        = "tf_k8s_sg_subnet"
  description = "k8s_sg_subnet"
  vpc_id      = "${aws_vpc.tf_k8s_vpc.id}"

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
    from_port   = 443
    to_port     = 443
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
    from_port   = -1
    to_port     = -1
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
  vpc_id      = "${aws_vpc.tf_k8s_vpc.id}"

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
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
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

## print vpc
output "k8s_vpc" {
  value = "${aws_vpc.tf_k8s_vpc.id}"
}
