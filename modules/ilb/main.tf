# Internal Load Balancer
resource "azurerm_lb" "ilb" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "ilb-frontend"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Backend Pool
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name                = var.backend_pool_name
  loadbalancer_id     = azurerm_lb.ilb.id
//  resource_group_name = var.resource_group_name
}

# Health Probe
resource "azurerm_lb_probe" "probe" {
  name                = "app-health-probe"
 // resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.ilb.id
  protocol            = "Tcp"
  port                = var.probe_port
}

# Load Balancer Rule
resource "azurerm_lb_rule" "lb_rule" {
  name                           = "app-lb-rule"
//  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.ilb.id
  protocol                       = "Tcp"
  frontend_port                  = var.lb_port
  backend_port                   = var.backend_port
  frontend_ip_configuration_name = "ilb-frontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.probe.id
}

# Associate NICs with backend pool
/* resource "azurerm_network_interface_backend_address_pool_association" "nic_assoc" {
  count                   = length(var.nic_ids)
  network_interface_id    = var.nic_ids[count.index]
  ip_configuration_name   = "${basename(var.nic_ids[count.index])}-ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
} */

resource "azurerm_network_interface_backend_address_pool_association" "nic_assoc" {
  count                   = length(var.nic_ids)
  network_interface_id    = var.nic_ids[count.index]
  ip_configuration_name   = var.nic_ip_config_names[count.index]
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}