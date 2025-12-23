resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Subnets

resource "azurerm_subnet" "agw" {
  name                 = "snet-agw"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnets.agw]
}

resource "azurerm_subnet" "web" {
  name                 = "snet-web"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnets.web]
}

resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnets.app]
}

resource "azurerm_subnet" "db" {
  name                 = "snet-db"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnets.db]
  delegation {
    name = "mysql-flexible-server-delegation"

    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}

# NSGs

# NSG for Application Gateway subnet
resource "azurerm_network_security_group" "nsg_agw" {
  name                = "nsg-agw"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Inbound: Internet -> AGW (80,443)
  security_rule {
    name                       = "Allow-HTTP-HTTPS-From-Internet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443"]
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  # Inbound: AzureLoadBalancer -> AGW (65200–65535)
  security_rule {
    name                       = "Allow-AzureLoadBalancer-Probe"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["65200-65535"]
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  # Inbound: Internet -> AGW (65200–65535)
  security_rule {
    name                       = "Allow-Internet-Ephemeral-Ports"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["65200-65535"]
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  # Outbound: AGW -> Web subnet (80,443)
  security_rule {
    name                       = "Allow-Outbound-To-Web-HTTP-HTTPS"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443"]
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_subnet.web.address_prefixes[0]
  }
}

# NSG for Web subnet
resource "azurerm_network_security_group" "nsg_web" {
  name                = "nsg-web"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Inbound: AGW subnet -> Web (80,443)
  security_rule {
    name                       = "Allow-AGW-To-Web-HTTP-HTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443"]
    source_address_prefix      = azurerm_subnet.agw.address_prefixes[0]
    destination_address_prefix = "*"
  }

  # Outbound: Web -> App subnet (8080)
  security_rule {
    name                       = "Allow-Outbound-To-App-8080"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["8080"]
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_subnet.app.address_prefixes[0]
  }

  
}

# NSG for App subnet
resource "azurerm_network_security_group" "nsg_app" {
  name                = "nsg-app"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Inbound: Web subnet -> App (8080)
  security_rule {
    name                       = "Allow-Web-To-App-8080"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["8080"]
    source_address_prefix      = azurerm_subnet.web.address_prefixes[0]
    destination_address_prefix = "*"
  }

  # Outbound: App -> DB subnet (3306)
  security_rule {
    name                       = "Allow-Outbound-To-DB-3306"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["3306"]
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_subnet.db.address_prefixes[0]
  }
}

# NSG for DB subnet
resource "azurerm_network_security_group" "nsg_db" {
  name                = "nsg-db"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Inbound: App subnet -> DB (3306)
  security_rule {
    name                       = "Allow-App-To-DB-3306"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["3306"]
    source_address_prefix      = azurerm_subnet.app.address_prefixes[0]
    destination_address_prefix = "*"
  }
}

# -------------------------
# NSG Associations
# -------------------------

resource "azurerm_subnet_network_security_group_association" "agw_assoc" {
  subnet_id                 = azurerm_subnet.agw.id
  network_security_group_id = azurerm_network_security_group.nsg_agw.id
}

resource "azurerm_subnet_network_security_group_association" "web_assoc" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.nsg_web.id
}

resource "azurerm_subnet_network_security_group_association" "app_assoc" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.nsg_app.id
}

resource "azurerm_subnet_network_security_group_association" "db_assoc" {
  subnet_id                 = azurerm_subnet.db.id
  network_security_group_id = azurerm_network_security_group.nsg_db.id
}