## AMIs debian stretch
variable "aws_amis_stretch" {
  description = "Debian stretch"
  default     = "ami-05cdaf7e7b6c76277"
}

## AMIs debian jessie
variable "aws_amis_jessie" {
  description = "Debian stretch"
  default     = "ami-3291be54"
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

variable "public_key_path" {
  type        = "string"
  description = "ssh key macbook"
  default     = "/Users/evenssolignac/.ssh/id_rsa.pub"
}

# Secrity groups for HTTP server
resource "aws_security_group" "tf-icmp-http-ssh" {
  name        = "tf-icmp-http-ssh"
  description = "ICMP/SSH/HTTP"

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
