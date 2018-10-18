## AMIs debian stretch
variable "aws_amis_stretch" {
  description = "Debian stretch"
  default     = "ami-0c0d066cb8b155cbe"
}

## AMIs debian jessie
variable "aws_amis_jessie" {
  description = "Debian stretch"
  default     = "ami-abff2ac4"
}

## SSH key file
variable "key_name" {
  description = "describe your variable"
  default     = "ESC"
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

variable "private_key_path" {
  type        = "string"
  description = "ssh private key macbook epi"
  default     = "/Users/evenssolignac/.ssh/id_rsa"
}

variable "public_key_path" {
  type        = "string"
  description = "ssh key macbook"
  default     = "/Users/evenssolignac/.ssh/id_rsa.pub"
}

variable "hostname" {
  description = "Define hostnames"

  default = {
    "0" = "ansible1"
    "1" = "ansible2"
  }
}

# Secrity groups for HTTP server
resource "aws_security_group" "tf_icmp_ssh" {
  name        = "tf_icmp_http_ssh"
  description = "ICMP/SSH/HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
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
