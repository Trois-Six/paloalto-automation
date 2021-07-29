data "aws_ami" "alpine" {
  most_recent = true

  filter {
    name   = "name"
    values = ["alpine-ami-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["538276064493"]
}

resource "aws_network_interface" "whoami" {
  subnet_id   = var.subnet_id
  private_ips = [var.ip]

  tags = merge(
    {
      "Name" = format("%s-whoami", var.name_prefix)
    },
    var.tags,
  )
}

resource "aws_instance" "whoami" {
  ami           = data.aws_ami.alpine.id
  instance_type = "t2.micro"
  key_name      = var.ssh_key_name

  user_data = file(abspath(format("%s/../../../common/whoami_user_data/user_data.sh", path.module)))

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.whoami.id
  }

  tags = merge(
    {
      "Name" = format("%s-whoami", var.name_prefix)
    },
    var.tags,
  )
}
