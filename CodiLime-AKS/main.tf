# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  #name     = "${var.prefix}-aks-resources"
  name     = local.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.prefix}-vnet"
  location            = var.location
  resource_group_name = local.resource_group_name
  address_space       = ["192.168.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = local.resource_group_name
  address_prefixes     = ["192.168.1.0/24"]
  virtual_network_name = azurerm_virtual_network.example.name
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_subnet" "waf-subnet" {
  name                 = "appgw-subnet"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes       = ["192.168.20.0/24"]
}

resource "azurerm_public_ip" "wafip" {
  name                = "waf-pip"
  resource_group_name = local.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

################################################################################################

##        Modules


module "aks" {
  source = "./aks"
  #resource_group_name = var.resource_group_name
  location = var.location
  prefix = var.prefix
  azurerm_virtual_network = azurerm_virtual_network.example
  subnet_id  = azurerm_subnet.example.id
  #azurerm_subnet = azurerm_subnet.example
  #azurerm_public_ip = data.azurerm_public_ip.example.ip_address
}



module "appgw" {
  source = "./appgw"
  resource_group_name = local.resource_group_name
  location = var.location
  frontdoor_name = "hmw-FrontDoor"
  routing_rule_name = "RoutingRule1"
  accepted_protocols = ["Http", "Https"]
  patterns_to_match = ["/*"]
  frontend_endpoints = ["FrontendEndpoint1"]
  #forwarding_protocol
  backend_pool_name = "exampleBackendBing"
  backend_pool_load_balancing_name = "LoadBalancingSettings1"
  backend_pool_health_probe_name = "HealthProbeSetting1"
  backend_host_header = "www.bing.com"
  backend_address = "linux-vm.qatarcentral.cloudapp.azure.com"
  backend_http_port  = 80
  backend_https_port  = 443
  frontend_endpoint_name = "FrontendEndpoint1"
  frontend_endpoint_host_name = "example-FrontDoor.azurefd.net"

  #subnet_id = azurerm_subnet.example.id
  waf_subnet = azurerm_subnet.waf-subnet.id
  wafip_id = azurerm_public_ip.wafip.id
}


module "bastion" {
  source = "./bastion"
  resource_group_name = local.resource_group_name
  location = var.location
  azurerm_virtual_network = azurerm_virtual_network.example
  azurerm_subnet = azurerm_subnet.example
  # azurerm_public_ip = data.azurerm_public_ip.example.ip_address
}


module "kv" {
  source = "./kv"
  resource_group_name = local.resource_group_name
  location = var.location
}