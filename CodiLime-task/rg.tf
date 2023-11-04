#terraform {
#  required_providers {
#    azurerm = {
#      source  = "hashicorp/azurerm"
#      version = "~>2.2.0"
#    }
#  }
#}

########################################################################################################################

resource "azurerm_resource_group" "infra" {
  name     = var.resource_group_name
  location = var.location
}

########################################################################################################################

resource "azurerm_availability_set" "avset" {
  name                         = "avset"
  location                     = var.location 
  resource_group_name          = var.resource_group_name 
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}
