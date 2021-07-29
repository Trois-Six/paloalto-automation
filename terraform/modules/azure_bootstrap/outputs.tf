output "storage_account" {
  value = azurerm_storage_account.this.name
}

output "storage_share" {
  value = azurerm_storage_share.this.name
}

output "primary_access_key" {
  value = azurerm_storage_account.this.primary_access_key
  sensitive = true
}
