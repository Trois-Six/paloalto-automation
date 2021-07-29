resource "azurerm_virtual_network" "this" {
  name                = var.name
  address_space       = [var.address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_route_table" "private" {
  name                = format("%s-${var.private_subnet_suffix}", var.name)
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_subnet" "private" {
  name                 = format("%s-${var.private_subnet_suffix}-%s", var.name, var.location)
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.private_subnet]
}

resource "azurerm_subnet_route_table_association" "private" {
  subnet_id      = azurerm_subnet.private.id
  route_table_id = azurerm_route_table.private.id
}
