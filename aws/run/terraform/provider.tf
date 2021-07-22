terraform {
  required_providers {
    panos = {
      source  = "paloaltonetworks/panos"
      version = ">= 1.8.3"
    }
  }

  required_version = ">= 0.15"
}

data "terraform_remote_state" "build" {
  backend = "local"

  config = {
    path = var.remote_state_path
  }
}

provider "panos" {
  hostname = data.terraform_remote_state.build.outputs.fw_mgmt_eip
  username = data.terraform_remote_state.build.outputs.fw_admin
  password = data.terraform_remote_state.build.outputs.fw_password
}
