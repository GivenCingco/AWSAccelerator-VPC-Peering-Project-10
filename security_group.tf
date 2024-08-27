module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws"

  count = 2
  name        = "web-server${count.index + 1}"
  description = "Security group for web-server with HTTP and SSH ports open within VPC"
  vpc_id      = module.vpc[count.index].vpc_id

    /*===Inbound Rules===*/
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"  
      description = "Allow SSH from your IP address"
    },
     {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow HTTP outbound traffic"
    },
     {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow ICMP inbound traffic to ping instances"
    }
  ]

    /*===Outbound Rules===*/
   egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow all outbound traffic"
    }
  ]

}

output "security_group_id" {
  value = module.web_server_sg[*].security_group_id
}
