module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name            = format("%s-vpc", var.name)
  cidr            = var.vpc_cidr_block
  azs             = slice(data.aws_availability_zones.available.names, 0, 1)
  public_subnets  = [var.public_subnet, var.mgmt_subnet]
  private_subnets = [var.private_subnet]

  tags = {
    Environment = "simple"
  }
}

module "create_bootstrap" {
  source = "../../../terraform/modules/create_bootstrap"

  name_prefix = var.name
  fw_admin    = var.fw_admin
}

module "bootstrap" {
  source = "../../../terraform/modules/aws_bootstrap"

  name_prefix = var.name
}

resource "aws_key_pair" "ssh_key" {
  key_name   = format("%s-ssh_key", var.name)
  public_key = file(var.public_key_file)

  tags = {
    Environment = "simple"
  }
}

module "firewall" {
  source = "../../../terraform/modules/aws_firewall"

  name_prefix          = var.name
  ssh_key_name         = aws_key_pair.ssh_key.key_name
  vpc_id               = module.vpc.vpc_id
  fw_mgmt_subnet_id    = module.vpc.public_subnets[1]
  fw_mgmt_ip           = cidrhost(var.mgmt_subnet, 4)
  fw_mgmt_allowed_from = var.fw_mgmt_allowed_from
  fw_eth1_subnet_id    = module.vpc.public_subnets[0]
  fw_eth1_ip           = cidrhost(var.public_subnet, 4)
  fw_eth2_subnet_id    = module.vpc.private_subnets[0]
  fw_eth2_ip           = cidrhost(var.private_subnet, 4)
  fw_version           = "10.1.0"
  fw_bootstrap_bucket  = module.bootstrap.bootstrap_bucket_name

  tags = {
    Environment = "simple"
  }
}

data "aws_route_table" "private" {
  route_table_id = module.vpc.private_route_table_ids.0
}

resource "aws_route" "private_default_route" {
  route_table_id         = data.aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.firewall.fw_eth2_id
}

module "whoami" {
  source = "../../../terraform/modules/aws_whoami"

  name_prefix  = var.name
  ssh_key_name = aws_key_pair.ssh_key.key_name
  subnet_id    = module.vpc.private_subnets[0]
  ip           = cidrhost(var.private_subnet, 10)

  tags = {
    Environment = "simple"
    Type        = "web"
  }
}
