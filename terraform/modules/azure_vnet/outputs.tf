output "private_subnet" {
  value = azurerm_subnet.private.id
}

output "private_route_table_name" {
    value = azurerm_route_table.private.name
}
