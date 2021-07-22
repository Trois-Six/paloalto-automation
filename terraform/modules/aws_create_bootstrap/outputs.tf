output "fw_password" {
  value     = random_password.password.result
  sensitive = true
}

output "bootstrap_xml_path" {
  value = abspath(format("%s/%s", path.module, var.bootstrap_xml_path))
}

output "init_cfg_path" {
  value = abspath(format("%s/%s", path.module, var.init_cfg_path))
}
