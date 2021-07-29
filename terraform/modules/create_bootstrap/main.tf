resource "random_password" "password" {
  length           = 16
  lower            = true
  special          = true
  override_special = "@#-_=+:"
  upper            = true
}

resource "random_password" "salt" {
  length  = 8
  lower   = true
  special = false
  upper   = true
}

data "external" "fw_hashed_password" {
  program = ["python3", abspath(format("%s/%s", path.module, "get_md5crypt_password.py"))]
  query = {
    password = random_password.password.result
    salt     = random_password.salt.result
  }
}

resource "local_file" "bootstrap" {
  content = templatefile(abspath(format("%s/%s", path.module, var.bootstrap_xml_tpl_path)), {
    fw_admin           = var.fw_admin,
    fw_hashed_password = data.external.fw_hashed_password.result["crypt_password"],
    fw_name            = format("%s-fw", var.name_prefix),
  })
  filename = abspath(format("%s/%s", path.module, var.bootstrap_xml_path))
}

resource "local_file" "init_cfg" {
  content = templatefile(abspath(format("%s/%s", path.module, var.init_cfg_tpl_path)), {
    fw_name = format("%s-fw", var.name_prefix),
  })
  filename = abspath(format("%s/%s", path.module, var.init_cfg_path))
}
