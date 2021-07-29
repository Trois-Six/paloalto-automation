resource "azurerm_storage_account" "this" {
  name                     = format("%ssta", var.name_prefix)
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "this" {
  name                 = "bootstrap"
  storage_account_name = azurerm_storage_account.this.name
  quota                = 1
}

resource "azurerm_storage_share_directory" "config" {
  name                 = "config"
  share_name           = azurerm_storage_share.this.name
  storage_account_name = azurerm_storage_account.this.name
}

resource "azurerm_storage_share_file" "init_cfg" {
  name = "init-cfg.txt"
  storage_share_id = azurerm_storage_share.this.id
  path = azurerm_storage_share_directory.config.name
  source = abspath(format("%s/%s", path.module, var.init_cfg_path))
}

resource "azurerm_storage_share_file" "bootstrap_xml" {
  name = "bootstrap.xml"
  storage_share_id = azurerm_storage_share.this.id
  path = azurerm_storage_share_directory.config.name
  source = abspath(format("%s/%s", path.module, var.init_cfg_path))
}

resource "azurerm_storage_share_directory" "directories" {
  for_each = toset([
    "content",
    "software",
    "plugins",
    "license"
  ])

  name = each.key
  share_name           = azurerm_storage_share.this.name
  storage_account_name = azurerm_storage_account.this.name
}
