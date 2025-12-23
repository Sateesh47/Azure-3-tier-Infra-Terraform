variable "rg_name" {
  type    = string
  default = "rg-3tier-dev"
}

variable "location" {
  type    = string
  default = "centralindia"
}

variable "admin_username" {
  type        = string
  description = "Admin username for all VMs"
  default     = "admin123"
}

variable "admin_password" {
  type        = string
  description = "Admin password for all VMs"
  sensitive   = true
}

variable "db_admin_username" {
  type        = string
  description = "MySQL admin username"
  default     = "mysqladmin"
}

variable "db_admin_password" {
  type        = string
  sensitive   = true
  description = "MySQL admin password"
}