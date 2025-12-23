terraform {
  backend "azurerm" {
    resource_group_name  = "sateesh0526"
    storage_account_name = "tfazurestorageaccount"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
