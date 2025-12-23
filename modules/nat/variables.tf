variable "resource_group_name" {
  description = "Resource group where NAT resources will be created"
  type        = string
}

variable "location" {
  description = "Azure region for NAT resources"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to associate the NAT Gateway with"
  type        = string
}

variable "nat_name" {
  description = "Name of the NAT Gateway"
  type        = string
  default     = "nat-app"
}

variable "public_ip_name" {
  description = "Name of the NAT Gateway public IP"
  type        = string
  default     = "pip-nat-app"
}