variable "name" {
  type    = string
  default = "jammy64"
}

variable "cpus" {
  type    = string
  default = "2"
}

variable "memory" {
  type    = string
  default = "1024"
}

variable "disk_size" {
  type    = string
  default = "204800"
}

variable "iso_checksum" {
  type    = string
  default = "10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"
}

variable "iso_checksum_type" {
  type    = string
  default = "sha256"
}

variable "iso_url" {
  type    = string
  default = "https://releases.ubuntu.com/22.04/ubuntu-22.04.1-live-server-amd64.iso"
}

variable "ssh_username" {
  type    = string
  default = "vagrant"
}

variable "ssh_password" {
  type    = string
  default = "vagrant"
}

variable "version" {
  type    = string
  default = "0.1"
}

locals {
  standard_tags = {
    Release     = "Jammy"
    Environment = "production"
  }
}

// AWS
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ami_description" {
  type    = string
  default = "aws ami instance bionic"
}

variable "source_ami" {
  type        = string
  default     = "ami-052efd3df9dad4825"
  description = "Ubuntu 22.04.1 LTS"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}