module "vpc" {
  source     = "./vpc"
  vpc_name   = var.vpc_name
  cidr_block = var.cidr_block
}

resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Name = "${var.vpc_name}-default"
  }
}

resource "aws_customer_gateway" "customer_gateways" {
  for_each   = var.customer_gateways
  bgp_asn    = var.bgp_asn
  ip_address = each.value.address
  type       = each.value.type
  tags = {
    Name = each.value.name
  }
}

resource "aws_vpn_connection" "vpn_connection" {
  for_each = aws_customer_gateway.customer_gateways

  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = each.value.id
  type                = each.value.type
  static_routes_only  = true

  tunnel1_preshared_key = var.customer_gateways[[for k, v in var.customer_gateways : k if v.name == aws_customer_gateway.customer_gateways[each.key].tags["Name"]][0]].shared_key
  tunnel2_preshared_key = var.customer_gateways[[for k, v in var.customer_gateways : k if v.name == aws_customer_gateway.customer_gateways[each.key].tags["Name"]][0]].shared_key

  local_ipv4_network_cidr = var.customer_gateways[[for k, v in var.customer_gateways : k if v.name == aws_customer_gateway.customer_gateways[each.key].tags["Name"]][0]].local_cidr
  remote_ipv4_network_cidr = var.customer_gateways[[for k, v in var.customer_gateways : k if v.name == aws_customer_gateway.customer_gateways[each.key].tags["Name"]][0]].remote_cidr

  tags = {
    Name = "${aws_customer_gateway.customer_gateways[each.key].tags["Name"]}-connection"
  }
}
