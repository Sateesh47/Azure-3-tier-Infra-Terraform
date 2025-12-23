# Private DNS Zone for MySQL Flexible Server
resource "azurerm_private_dns_zone" "mysql_dns" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_mysql_flexible_server" "mysql" {
  name                = var.mysql_name
  resource_group_name = var.resource_group_name
  location            = var.location

  administrator_login    = var.admin_username
  administrator_password = var.admin_password

  version = "8.0.21"
  sku_name = var.sku_name

  storage {
    size_gb = var.storage_size_gb
  }

  backup_retention_days = 7

  /*high_availability {
    mode = "Disabled"
  } */

  # Very important for private access
  delegated_subnet_id = var.subnet_id
  private_dns_zone_id = azurerm_private_dns_zone.mysql_dns.id

  tags = var.tags
}