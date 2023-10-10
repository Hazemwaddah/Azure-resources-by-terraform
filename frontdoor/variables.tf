# Global Variables

variable "location" {}
variable "client_id" {}
variable "client_secret" {}
variable "subscription_id" {}
variable "tenant_id" {}
variable "resource_group_name" {}
variable "virtual_network_name" {}
variable "subnet_name" {}

########################################################################################################################

# linux-server 

variable "linux_network_interface_name" {}
variable "linux_ip_configuration_name" {}
variable "linux_vm_name" {}
variable "linux_vm_size" {}
variable "linux_image_publisher" {}
variable "linux_image_sku" {}
variable "linux_image_version" {}
variable "linux_image_offer" {}
variable "linux_admin_username" {}
variable "linux_admin_password" {}

########################################################################################################################

#  frontdoor

variable "frontdoor_name" {}
variable "routing_rule_name" {}
variable "accepted_protocols" { type = list(string) }
variable "patterns_to_match" { type = list(string) }
variable "frontend_endpoints" { type = list(string) }
#variable "forwarding_protocol" {}
variable "backend_pool_name" {}
variable "backend_pool_load_balancing_name" {}
variable "backend_pool_health_probe_name" {}
variable "backend_host_header" {}
variable "backend_address" {}
variable "backend_http_port" { type = number }
variable "backend_https_port" { type = number }
variable "frontend_endpoint_name" {}
variable "frontend_endpoint_host_name" {}

########################################################################################################################

provider "azurerm" {
  features {}
  subscription_id  = var.subscription_id
 # client_id       = var.client_id
 # client_secret   = var.client_secret
  tenant_id        = var.tenant_id
}
########################################################################################################################

resource "azurerm_resource_group" "infra" {
  name     = var.resource_group_name
  location = var.location
}


