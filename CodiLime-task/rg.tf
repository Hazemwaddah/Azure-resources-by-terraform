#terraform {
#  required_providers {
#    azurerm = {
#      source  = "hashicorp/azurerm"
#      version = "~>2.2.0"
#    }
#  }
#}

provider "azurerm" {
  features {}
}
########################################################################################################################

resource "azurerm_resource_group" "infra" {
  name     = var.resource_group_name
  location = var.location
}

########################################################################################################################

resource "azurerm_availability_set" "avset" {
  name                         = "avset"
  location                     = azurerm_resource_group.infra.location
  resource_group_name          = azurerm_resource_group.infra.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 1
  managed                      = true
}
