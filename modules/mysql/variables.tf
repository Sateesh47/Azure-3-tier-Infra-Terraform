variable "resource_group_name" {
  type        = string
  description = "Resource group for MySQL resources"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "mysql_name" {
  type        = string
  description = "Name of the MySQL Flexible Server"
}

variable "admin_username" {
  type        = string
  description = "MySQL admin username"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "MySQL admin password"
}

variable "subnet_id" {
  type        = string
  description = "Delegated subnet ID for MySQL Flexible Server (DB subnet)"
}

variable "sku_name" {
  type        = string
  description = "SKU name for MySQL Flexible Server"
  default     = "B_Standard_B1ms"
}

variable "storage_size_gb" {
  type        = number
  description = "MySQL storage size in GB"
  default     = 20
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to MySQL resources"
  default     = {}
}