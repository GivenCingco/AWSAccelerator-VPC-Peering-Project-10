provider "tls" {
}

resource "tls_private_key" "this" {
  count     = 2
  algorithm = "RSA"
}

resource "aws_secretsmanager_secret" "ec2_key_pair" {
  count       = 2
  name        = "ec2-key-pair-${count.index + 1}"
  description = "EC2 Key Pair for SSH access"
}

resource "aws_secretsmanager_secret_version" "ec2_key_pair" {
  count        = 2
  secret_id    = aws_secretsmanager_secret.ec2_key_pair[count.index].id
  secret_string = jsonencode({
    private_key = tls_private_key.this[count.index].private_key_pem
    public_key  = tls_private_key.this[count.index].public_key_openssh
  })
}

module "key_pair" {
  count      = 2
  source     = "terraform-aws-modules/key-pair/aws"
  key_name   = "ec2-key-pair-${count.index + 1}"
  public_key = trimspace(tls_private_key.this[count.index].public_key_openssh)
}
