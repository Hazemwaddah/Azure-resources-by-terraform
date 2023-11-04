output "resource_group_name" {
  description = "The name of the resource group"
  #value       = azurerm_resource_group_name.infra.name
  value = var.resource_group_name
}

output "location" {
  description = "The location of the resource group"
  #value       = azurerm_resource_group_name.infra.location
  value = var.location
}

output "linux_network_interface_name" {
  #value = azurerm_network_interface.linux.name
  value = values(azurerm_network_interface.linux)[*].name
}

output "linux_network_interface_id" {
  description = "The ID of the Linux network interface"
  value       = values(azurerm_network_interface.linux)[*].id
}

#locals {
# linux_network_interface_ids = {
#  instance1 = module.vm.linux_network_interface_id[0]
#  instance2 = module.vm.linux_network_interface_id[1]
# }
#}

output "linux_ip_configuration_name" {
  value = var.linux_ip_configuration_name
}
