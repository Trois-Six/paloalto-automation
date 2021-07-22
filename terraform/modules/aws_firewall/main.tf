data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "fw_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [format("PA-VM-AWS*%s*", var.fw_version)]
  }

  owners = ["aws-marketplace"]
}

resource "aws_instance" "fw" {
  ami           = data.aws_ami.fw_ami.id
  instance_type = var.fw_instance_type
  key_name      = var.ssh_key_name

  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "stop"

  ebs_optimized = true

  root_block_device {
    volume_type           = "gp2"
    delete_on_termination = true
  }

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.fw_mgmt.id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.fw_eth1.id
  }

  network_interface {
    device_index         = 2
    network_interface_id = aws_network_interface.fw_eth2.id
  }

  iam_instance_profile = aws_iam_instance_profile.fw_bootstrap.name
  user_data            = base64encode(format("vmseries-bootstrap-aws-s3bucket=%s", var.fw_bootstrap_bucket))

  lifecycle {
    ignore_changes = [user_data, volume_tags]
  }

  tags = merge(
    {
      "Name" = format("fw-%s", var.name_suffix)
    },
    var.tags,
  )
}

resource "aws_security_group" "public" {
  name        = format("public-%s", var.name_suffix)
  description = "Wide open security group for firewall external interfaces."
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      "Name" = format("public-%s", var.name_suffix)
    },
    var.tags,
  )
}

resource "aws_security_group" "firewall_mgmt" {
  name        = format("fw-mgmt-%s", var.name_suffix)
  description = "Firewall Management Security Group."
  vpc_id      = var.vpc_id

  ingress {
    to_port     = 22
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = var.fw_mgmt_allowed_from
  }

  ingress {
    to_port     = 443
    from_port   = 443
    protocol    = "tcp"
    cidr_blocks = var.fw_mgmt_allowed_from
  }

  ingress {
    to_port     = 0
    from_port   = 8
    protocol    = "icmp"
    cidr_blocks = var.fw_mgmt_allowed_from
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      "Name" = format("fw-mgmt-%s", var.name_suffix)
    },
    var.tags,
  )
}

resource "aws_network_interface" "fw_mgmt" {
  subnet_id       = var.fw_mgmt_subnet_id
  private_ips     = [var.fw_mgmt_ip]
  security_groups = [aws_security_group.firewall_mgmt.id]

  tags = merge(
    {
      "Name" = format("fw-mgmt-%s", var.name_suffix)
    },
    var.tags,
  )
}

resource "aws_network_interface" "fw_eth1" {
  subnet_id         = var.fw_eth1_subnet_id
  private_ips       = [var.fw_eth1_ip]
  security_groups   = [aws_security_group.public.id]
  source_dest_check = false

  tags = merge(
    {
      "Name" = format("fw-eth1-%s", var.name_suffix)
      "Zone" = "untrust"
    },
    var.tags,
  )
}

resource "aws_network_interface" "fw_eth2" {
  subnet_id         = var.fw_eth2_subnet_id
  private_ips       = [var.fw_eth2_ip]
  source_dest_check = false

  tags = merge(
    {
      "Name" = format("fw-eth2-%s", var.name_suffix)
      "Zone" = "trust"
    },
    var.tags,
  )
}

resource "aws_eip" "fw_mgmt" {
  vpc = true

  tags = merge(
    {
      "Name" = format("fw-mgmt-%s", var.name_suffix)
    },
    var.tags,
  )
}

resource "aws_eip_association" "fw_mgmt" {
  allocation_id        = aws_eip.fw_mgmt.id
  network_interface_id = aws_network_interface.fw_mgmt.id
}

resource "aws_eip" "fw_eth1" {
  vpc = true

  tags = merge(
    {
      "Name" = format("fw-eth1-%s", var.name_suffix)
    },
    var.tags,
  )
}

resource "aws_eip_association" "fw_eth1" {
  allocation_id        = aws_eip.fw_eth1.id
  network_interface_id = aws_network_interface.fw_eth1.id
}

resource "aws_iam_role" "fw_bootstrap" {
  name = format("fw-bootstrap-%s", var.name_suffix)
  assume_role_policy = file(abspath(format("%s/%s", path.module, var.iam_role_document_path)))

  tags = merge(
    {
      "Name" = format("fw-bootstrap-%s", var.name_suffix)
    },
    var.tags,
  )
}

resource "aws_iam_role_policy" "fw_bootstrap" {
  name = format("fw-bootstrap-%s", var.name_suffix)
  role = aws_iam_role.fw_bootstrap.id
  policy = file(abspath(format("%s/%s", path.module, var.iam_policy_document_path)))
}

resource "aws_iam_instance_profile" "fw_bootstrap" {
  name = format("fw-bootstrap-%s", var.name_suffix)
  role = aws_iam_role.fw_bootstrap.name
  path = "/"
}

resource "null_resource" "wait" {
  depends_on = [aws_instance.fw]

  provisioner "local-exec" {
    command = format("python3 %s %s", abspath(format("%s/wait_for_fw.py", path.module)), aws_eip.fw_mgmt.public_ip)
  }
}
