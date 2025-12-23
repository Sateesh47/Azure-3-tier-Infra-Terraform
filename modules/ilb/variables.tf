variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the ILB frontend will be placed"
  type        = string
}

variable "lb_name" {
  description = "Name of the internal load balancer"
  type        = string
  default     = "ilb-app"
}

variable "backend_pool_name" {
  description = "Name of the backend pool"
  type        = string
  default     = "app-backend-pool"
}

variable "probe_port" {
  description = "Port for health probe"
  type        = number
  default     = 8080
}

variable "lb_port" {
  description = "Frontend port for load balancer"
  type        = number
  default     = 8080
}

variable "backend_port" {
  description = "Backend port for load balancer"
  type        = number
  default     = 8080
}

variable "nic_ids" {
  description = "List of NIC IDs for backend pool"
  type        = list(string)
}

variable "nic_ip_config_names" {
  type = list(string)
}