output "ilb_private_ip" {
  description = "Private IP of the internal load balancer"
  value       = azurerm_lb.ilb.frontend_ip_configuration[0].private_ip_address
}

output "backend_pool_id" {
  description = "Backend pool ID"
  value       = azurerm_lb_backend_address_pool.backend_pool.id
}