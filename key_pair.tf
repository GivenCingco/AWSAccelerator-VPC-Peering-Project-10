provider "tls" {
}

resource "tls_private_key" "this" {
  count  = 2
  algorithm = "RSA"
}

resource "local_file" "private_key" {
  count  = 2
  content  = tls_private_key.this[count.index].private_key_pem
  filename = "${path.module}/key${count.index + 1}.pem"
}

module "key_pair" {
  count  = 2
  source = "terraform-aws-modules/key-pair/aws"
  key_name   = "ec2-key-pair-${count.index + 1}"
  public_key = trimspace(tls_private_key.this[count.index].public_key_openssh)
}
