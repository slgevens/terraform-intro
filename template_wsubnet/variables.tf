## AMIs debian stretch
variable "aws_amis_stretch" {
  description = "Debian stretch"
  default     = "ami-0c0d066cb8b155cbe"
}

## SSH key file and configuration
variable "key_name" {
  description = "tf_template_wsubnet_esc_key"
  default     = "tf_template_wsubnet_esc"
}

variable "public_key_path" {
  type        = "string"
  description = "ssh macbook epi"
  default     = "/Users/evenssolignac/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  type        = "string"
  description = "ssh private key macbook epi"
  default     = "/Users/evenssolignac/.ssh/id_rsa"
}

## Hostnames and count of nodes
variable "hostname" {
  description = "Define hostnames"

  default = {
    "0" = "template_wsubneta1"
    "1" = "template_wsubnetb1"
  }
}
## Hostnames and count of nodes
variable "hostname_private" {
  description = "Define hostnames"

  default = {
    "0" = "template_wsubnetc1_priv"
    "1" = "template_wsubnetd1_priv"
  }
}

variable "private_ips" {
  description = "Define private_ips"
  default = {
    "0" = "10.0.1.22"
    "1" = "10.0.1.23"
  }
}
variable "private_private_ips" {
  description = "Define private_ips"
  default = {
    "0" = "10.0.2.22"
    "1" = "10.0.2.23"
  }
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_cidr" {
  description = "CIDR for the public subnet"
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
