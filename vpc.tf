module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  count = 2

  name = "demo-vpc-${count.index + 1}"
  cidr = "10.${count.index + 1}.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.${count.index + 1}.1.0/24", "10.${count.index + 1}.2.0/24"]
  public_subnets  = ["10.${count.index + 1}.101.0/24", "10.${count.index + 1}.102.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
    VPC_Instance = "${count.index + 1}"
  }
}

module "vpc_peering" {
  source = "./vpc_peering_module"

  requestor_vpc_id         = module.vpc[0].vpc_id
  acceptor_vpc_id          = module.vpc[1].vpc_id
  requestor_route_table_id = module.vpc[0].public_route_table_ids[0]
  acceptor_route_table_id  = module.vpc[1].public_route_table_ids[0]
  requestor_cidr_block     = module.vpc[0].vpc_cidr_block
  acceptor_cidr_block      = module.vpc[1].vpc_cidr_block
}

output "vpc_id" {
  value = module.vpc[*].vpc_id
}

output "public_subnets" {
  value = flatten([for vpc in module.vpc : vpc.public_subnets])
}


output "vpc_peering_connection_id" {
  value = module.vpc_peering.vpc_peering_connection_id
}
output "vpc_cidr_block" {
  value = module.vpc[*].vpc_cidr_block
}