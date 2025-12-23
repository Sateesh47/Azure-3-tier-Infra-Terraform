output "vm_id" {
  description = "ID of the VM"
  value       = azurerm_linux_virtual_machine.vm.id
}

output "vm_name" {
  description = "Name of the VM"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "private_ip" {
  description = "Private IP address of the VM"
  value       = azurerm_network_interface.vm_nic.ip_configuration[0].private_ip_address
}

output "public_ip" {
  description = "Public IP address of the VM (if allocated)"
  value       = var.allocate_public_ip ? azurerm_public_ip.vm_pip[0].ip_address : null
}

output "nic_id" {
  description = "Network Interface ID"
  value       = azurerm_network_interface.vm_nic.id
}