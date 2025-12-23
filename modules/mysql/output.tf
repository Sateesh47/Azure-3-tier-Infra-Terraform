output "mysql_fqdn" {
  description = "Private FQDN of the MySQL Flexible Server"
  value       = azurerm_mysql_flexible_server.mysql.fqdn
}

output "mysql_name" {
  description = "Name of the MySQL Flexible Server"
  value       = azurerm_mysql_flexible_server.mysql.name
}

output "private_dns_zone_name" {
  description = "Private DNS zone name used by MySQL"
  value       = azurerm_private_dns_zone.mysql_dns.name
}