output "fw_admin" {
  value = var.fw_admin
}

output "fw_password" {
  value     = module.create_bootstrap.fw_password
  sensitive = true
}

output "fw_mgmt_ip" {
  value = module.firewall.fw_mgmt_ip
}

output "fw_mgmt_eip" {
  value = module.firewall.fw_mgmt_eip
}

output "fw_untrust_ip" {
  value = module.firewall.fw_eth1_ip
}

output "fw_untrust_eip" {
  value = module.firewall.fw_eth1_eip
}

output "fw_trust_ip" {
  value = module.firewall.fw_eth2_ip
}

output "whoami_ip" {
  value = module.whoami.whoami_ip
}
