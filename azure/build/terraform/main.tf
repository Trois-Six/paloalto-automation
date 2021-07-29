resource "azurerm_resource_group" "rg" {
  name     = format("%s-rg", var.name)
  location = var.azure_location

  tags = {
    Environment = "simple"
  }
}

module "vnet" {
  source = "../../../terraform/modules/azure_vnet"

  name                = format("%s-vnet", var.name)
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.azure_location
  address_space       = var.vnet_address_space
  private_subnet      = var.private_subnet
}

module "create_bootstrap" {
  source = "../../../terraform/modules/create_bootstrap"

  name_prefix = var.name
  fw_admin    = var.fw_admin
}

module "bootstrap" {
  source = "../../../terraform/modules/azure_bootstrap"

  name_prefix         = var.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.azure_location
}

// TODO: firewall + whoami Terraform modules