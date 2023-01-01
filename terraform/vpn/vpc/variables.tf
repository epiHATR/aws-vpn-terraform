variable "vpc_name" {
  type = string
}

variable "instance_tenancy" {
  type = string
  default = "default"
}

variable "cidr_block" {
  type = string
}