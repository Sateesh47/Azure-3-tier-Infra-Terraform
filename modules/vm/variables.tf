variable "resource_group_name" {
  description = "Resource group where the VM resources will be created"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the VM NIC will be placed"
  type        = string
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B2ms"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB"
  type        = number
  default     = 64
}

variable "allocate_public_ip" {
  description = "Whether to allocate a public IP for the VM"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the VM and related resources"
  type        = map(string)
  default     = {}
}