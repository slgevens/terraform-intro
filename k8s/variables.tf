## Count of nodes
variable "count" {
  default = 2
}

## AMIs debian stretch
variable "aws_amis_stretch" {
  description = "Debian stretch"
  default     = "ami-05cdaf7e7b6c76277"
}

## SSH key file and configuration
variable "key_name" {
  description = "tf_k8s_esc_key"
  default     = "tf_k8s_esc"
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

## Hostnames
variable "hostname" {
  description = "Define hostnames"

  default = {
    "0" = "k8sa1"
    "1" = "k8sb1"
  }
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default     = "172.10.0.0/16"
}

# variable "vpc_id" {
#   description = "ID for VPC"
#   default     = "${aws_vpc.tf_k8s_vpc.0.id}"
# }

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default     = "172.10.1.0/24"
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
