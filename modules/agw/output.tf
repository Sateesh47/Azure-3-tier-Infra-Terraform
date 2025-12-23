output "agw_public_ip" {
  description = "Public IP of the Application Gateway"
  value       = azurerm_public_ip.agw_pip.ip_address
}

output "agw_name" {
  description = "Name of the Application Gateway"
  value       = azurerm_application_gateway.agw.name
}