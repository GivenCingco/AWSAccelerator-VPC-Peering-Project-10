// Define the VPC Peering Connection
resource "aws_vpc_peering_connection" "foo" {
  vpc_id      = var.requestor_vpc_id
  peer_vpc_id = var.acceptor_vpc_id
  auto_accept = true
}

// Define VPC Peering Connection Options
resource "aws_vpc_peering_connection_options" "foo" {
  vpc_peering_connection_id = aws_vpc_peering_connection.foo.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

/*==============================Update Route Tables====================*/

// Route table from Requestor VPC to Acceptor VPC
resource "aws_route" "requestor_to_acceptor" {
  route_table_id             = var.requestor_route_table_id
  destination_cidr_block     = var.acceptor_cidr_block
  vpc_peering_connection_id  = aws_vpc_peering_connection.foo.id
}

// Route table from Acceptor VPC to Requestor VPC
resource "aws_route" "acceptor_to_requestor" {
  route_table_id             = var.acceptor_route_table_id
  destination_cidr_block     = var.requestor_cidr_block
  vpc_peering_connection_id  = aws_vpc_peering_connection.foo.id
}          

/*==============================Outputs====================*/

output "vpc_peering_connection_id" {
  value = aws_vpc_peering_connection.foo.id
}

output "vpc_peering_connection_options_id" {
  value = aws_vpc_peering_connection_options.foo.id
}