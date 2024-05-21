########################################################################################################################

# Variables:

variable "location" {}
variable "client_id" {}
variable "client_secret" {}
variable "subscription_id" {}
variable "tenant_id" {}
variable "resource_group_name" {}
variable "virtual_network_name" {}
variable "network_interface_name" {}
variable "ip_configuration_name" {}
variable "vm_name" {}
variable "vm_size" {}
variable "image_publisher" {}
variable "image_sku" {}
variable "image_version" {}
variable "admin_username" {}
variable "admin_password" {}
variable "subnet_name" {}
variable "image_offer" {}

########################################################################################################################

#provider "azurerm" {
#  features {}
#  subscription_id = var.subscription_id
# client_id       = var.client_id
# client_secret   = var.client_secret
#  tenant_id       = var.tenant_id
#}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "example" {
  name                = var.virtual_network_name
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "example-publicip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "example" {
  name                = var.network_interface_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.vm_size

 #  delete_os_disk_on_termination    = true
 #  delete_data_disks_on_termination = true

  network_interface_ids = [azurerm_network_interface.example.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
  disable_password_authentication = false
  computer_name   = var.vm_name
  admin_username   = var.admin_username
  admin_password   = var.admin_password
}
