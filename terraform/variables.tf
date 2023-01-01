variable "vpc_name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "customer_gateways" {
  type = map(
    object({
      address    = string
      type       = string
      name       = string
      shared_key = string
      local_cidr = string
      remote_cidr = string
    })
  )
  default = {
  }
}
