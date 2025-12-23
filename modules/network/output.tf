output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value = {
    agw = azurerm_subnet.agw.id
    web = azurerm_subnet.web.id
    app = azurerm_subnet.app.id
    db  = azurerm_subnet.db.id
  }
}

output "subnet_address_prefixes" {
  description = "Map of subnet names to their address prefixes"
  value = {
    agw = azurerm_subnet.agw.address_prefixes[0]
    web = azurerm_subnet.web.address_prefixes[0]
    app = azurerm_subnet.app.address_prefixes[0]
    db  = azurerm_subnet.db.address_prefixes[0]
  }
}

output "nsg_ids" {
  description = "Map of NSG names to their IDs"
  value = {
    agw = azurerm_network_security_group.nsg_agw.id
    web = azurerm_network_security_group.nsg_web.id
    app = azurerm_network_security_group.nsg_app.id
    db  = azurerm_network_security_group.nsg_db.id
  }
}