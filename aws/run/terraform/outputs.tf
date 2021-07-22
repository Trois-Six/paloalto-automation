output "fw_admin" {
  value = data.terraform_remote_state.build.outputs.fw_admin
}

output "fw_password" {
  value = data.terraform_remote_state.build.outputs.fw_password
}

output "fw_mgmt_eip" {
  value = data.terraform_remote_state.build.outputs.fw_mgmt_eip
}
