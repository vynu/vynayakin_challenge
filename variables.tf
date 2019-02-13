variable "aws_region" {
  description = "Region for the VPC"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default     = "172.16.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default     = "172.16.10.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default     = "172.16.11.0/24"
}

variable "key_path" {
  description = "SSH Public Key path"
  default     = "/Users/vynu/.ssh/id_rsa.pub"
}

variable "crt_file" {
  description = ".crt file location"
  default = "server.crt"
}

variable "key_file" {
  description = ".key file location"
  default = "server.key"
}
