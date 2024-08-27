// variables.tf

variable "requestor_vpc_id" {
  description = "The ID of the requestor VPC"
  type        = string
}

variable "acceptor_vpc_id" {
  description = "The ID of the acceptor VPC"
  type        = string
}

variable "requestor_route_table_id" {
  description = "The route table ID of the requestor VPC"
  type        = string
}

variable "acceptor_route_table_id" {
  description = "The route table ID of the acceptor VPC"
  type        = string
}

variable "requestor_cidr_block" {
  description = "The CIDR block of the requestor VPC"
  type        = string
}

variable "acceptor_cidr_block" {
  description = "The CIDR block of the acceptor VPC"
  type        = string
}