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