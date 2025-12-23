variable "resource_group_name" {
  type        = string
  description = "Resource group for Application Gateway"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for Application Gateway (agw subnet)"
}

variable "agw_name" {
  type        = string
  description = "Name of the Application Gateway"
  default     = "app-gateway"
}

variable "backend_ip_addresses" {
  type        = list(string)
  description = "List of private IPs of Web VMs"
}

variable "tags" {
  type        = map(string)
  default     = {}
}