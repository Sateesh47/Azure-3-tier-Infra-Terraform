module "rg" {
  source   = "./modules/rg"
  rg_name  = var.rg_name
  location = var.location
}


module "network" {
  source = "./modules/network"

  resource_group_name = module.rg.rg_name
  location            = module.rg.location

  vnet_name = "vnet-3tier"
  vnet_cidr = "10.0.0.0/16"
  subnets = {
    agw = "10.0.1.0/24"
    web = "10.0.2.0/24"
    app = "10.0.3.0/24"
    db  = "10.0.4.0/24"
  }
}

module "nat_app" {
  source              = "./modules/nat"
  resource_group_name = module.rg.rg_name
  location            = module.rg.location
  subnet_id           = module.network.subnet_ids["app"]

  nat_name       = "nat-app"
  public_ip_name = "pip-nat-app"
}


module "web_vm" {
  source              = "./modules/vm"
  resource_group_name = module.rg.rg_name
  location            = module.rg.location

  vm_name        = "vm-web-01"
  subnet_id      = module.network.subnet_ids["web"]
  vm_size        = "Standard_B2ms"
  admin_username = var.admin_username
  admin_password = var.admin_password

  allocate_public_ip = false

  tags = {
    role = "web"
    tier = "frontend"
  }
}


module "app_vm" {
  source              = "./modules/vm"
  resource_group_name = module.rg.rg_name
  location            = module.rg.location

  vm_name        = "vm-app-01"
  subnet_id      = module.network.subnet_ids["app"]
  vm_size        = "Standard_B2ms"
  admin_username = var.admin_username
  admin_password = var.admin_password

  allocate_public_ip = false

  tags = {
    role = "app"
    tier = "backend"
  }
}

module "ilb_app" {
  source              = "./modules/ilb"
  resource_group_name = module.rg.rg_name
  location            = module.rg.location

  subnet_id = module.network.subnet_ids["app"]
  nic_ip_config_names = ["vm-app-01-ipconfig"]
  

  nic_ids = [
    module.app_vm.nic_id
  ]
}

module "mysql" {
  source              = "./modules/mysql"
  resource_group_name = module.rg.rg_name
  location            = module.rg.location

  mysql_name     = "mysql-db-01-0526"
  admin_username = var.db_admin_username
  admin_password = var.db_admin_password

  subnet_id = module.network.subnet_ids["db"]

  tags = {
    tier = "database"
    env  = "dev"
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql_dns_link" {
  name                  = "mysql-dns-link"
  resource_group_name   = module.rg.rg_name
  private_dns_zone_name = module.mysql.private_dns_zone_name
  virtual_network_id    = module.network.vnet_id

  registration_enabled = false
}

module "agw" {
  source              = "./modules/agw"
  resource_group_name = module.rg.rg_name
  location            = module.rg.location

  subnet_id = module.network.subnet_ids["agw"]

  backend_ip_addresses = [
    module.web_vm.private_ip
  ]

  tags = {
    tier = "gateway"
    env  = "dev"
  }
}