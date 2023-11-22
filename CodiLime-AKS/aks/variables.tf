data "azurerm_client_config" "current" {}

variable "location" {}
variable "azurerm_virtual_network" {}


variable "subnet_id" {
  description = "The ID of the Subnet"
  type        = string
}

variable "prefix" {
  description = "A prefix used for all resources in this example"
}


locals {
  resource_group_name     = "${var.prefix}-aks-resources"
}
