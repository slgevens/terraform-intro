## vpc
resource "aws_vpc" "tf_template_wsubnet_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  instance_tenancy     = "${var.instance_tenancy}"
  enable_dns_support   = "${var.dns_support}"
  enable_dns_hostnames = "${var.dns_hostnames}"
  tags {
    Name = "tf_template_wsubnet_vpc"
  }
}

## elastic ip
resource "aws_eip" "tf_template_wsubnet_eip" {
  vpc            = "True"
  depends_on     = ["aws_vpc.tf_template_wsubnet_vpc"]
  tags {
    Name = "tf_template_wsubnet_eip"
  }
}

## nat gateway
resource "aws_nat_gateway" "tf_template_wsubnet_nat_gateway" {
  allocation_id = "${aws_eip.tf_template_wsubnet_eip.id}"
  subnet_id     = "${aws_subnet.tf_template_wsubnet_pub_subnet.id}"
  depends_on     = ["aws_vpc.tf_template_wsubnet_vpc"]
  tags {
    Name = "tf_template_wsubnet_nat_gateway"
  }
}

## internet gateway
resource "aws_internet_gateway" "tf_template_wsubnet_internetgw" {
  depends_on = ["aws_vpc.tf_template_wsubnet_vpc"]
  vpc_id     = "${aws_vpc.tf_template_wsubnet_vpc.id}"
  tags {
    Name = "tf_template_wsubnet_internet_gw"
  }
}

# Secrity groups
resource "aws_security_group" "tf_template_wsubnet_sg_subnet" {
  name        = "tf_template_wsubnet_sg_subnet"
  description = "tf_template_wsubnet_sg_subnet"
  vpc_id      = "${aws_vpc.tf_template_wsubnet_vpc.id}"

  tags {
    Name = "tf_template_wsubnet_sg_subnet"
  }

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

resource "aws_security_group" "tf_template_wsubnet_sg_default" {
  name        = "tf_template_wsubnet_sg_default"
  description = "tf_template_wsubnet_sg_default"
  vpc_id      = "${aws_vpc.tf_template_wsubnet_vpc.id}"

  tags {
    Name = "tf_template_wsubnet_sg_default"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## public subnet
resource "aws_subnet" "tf_template_wsubnet_pub_subnet" {
  depends_on              = ["aws_vpc.tf_template_wsubnet_vpc"]
  vpc_id                  = "${aws_vpc.tf_template_wsubnet_vpc.id}"
  cidr_block              = "${var.public_cidr}"
  map_public_ip_on_launch = true
  
  tags {
    Name = "tf_template_wsubnet_public_subnet"
  }
}

## route table
resource "aws_route_table" "tf_template_wsubnet_pub_routetable" {
  vpc_id     = "${aws_vpc.tf_template_wsubnet_vpc.id}"
  depends_on = ["aws_vpc.tf_template_wsubnet_vpc"]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.tf_template_wsubnet_internetgw.id}"
  }

  tags {
    Name = "tf_template_wsubnet_pub_routetable"
  }
}

## route table association public
resource "aws_route_table_association" "tf_template_wsubnet_pub_routetable_association" {
  subnet_id      = "${aws_subnet.tf_template_wsubnet_pub_subnet.id}"
  route_table_id = "${aws_route_table.tf_template_wsubnet_pub_routetable.id}"
  depends_on     = ["aws_vpc.tf_template_wsubnet_vpc"]
}

## private subnet
resource "aws_subnet" "tf_template_wsubnet_priv_subnet" {
  depends_on = ["aws_vpc.tf_template_wsubnet_vpc"]
  vpc_id     = "${aws_vpc.tf_template_wsubnet_vpc.id}"
  cidr_block = "${var.private_cidr}"
  tags {
    Name = "tf_template_wsubnet_private_subnet"
  }
}


resource "aws_route_table" "tf_template_wsubnet_priv_routetable" {
  vpc_id     = "${aws_vpc.tf_template_wsubnet_vpc.id}"
  depends_on = ["aws_vpc.tf_template_wsubnet_vpc"]
  tags {
    Name = "tf_template_wsubnet_priv_routetable"
  }
}

## route table association private
resource "aws_route_table_association" "tf_template_wsubnet_priv_routetable_association" {
  subnet_id      = "${aws_subnet.tf_template_wsubnet_priv_subnet.id}"
  route_table_id = "${aws_route_table.tf_template_wsubnet_priv_routetable.id}"
  depends_on     = ["aws_vpc.tf_template_wsubnet_vpc"]
}

## route
resource "aws_route" "tf_template_wsubnet_priv_route" {
  route_table_id = "${aws_route_table.tf_template_wsubnet_priv_routetable.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_nat_gateway.tf_template_wsubnet_nat_gateway.id}"  
}
