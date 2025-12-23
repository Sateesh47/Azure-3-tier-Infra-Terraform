variable "resource_group_name" {
  description = "Name of the resource group where network resources will be created"
  type        = string
}

variable "location" {
  description = "Azure region for all network resources"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "vnet-3tier"
}

variable "vnet_cidr" {
  description = "Address space for the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnets" {
  description = "Map of subnet names to CIDR prefixes"
  type = object({
    agw = string
    web = string
    app = string
    db  = string
  })

  default = {
    agw = "10.0.1.0/24"
    web = "10.0.2.0/24"
    app = "10.0.3.0/24"
    db  = "10.0.4.0/24"
  }
}