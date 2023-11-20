resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name = var.resource_group_name
  virtual_network_name = var.azurerm_virtual_network.name
  address_prefixes     =  ["192.168.2.0/24"]
  #address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "bastionip" {
  name                = "bastion-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "example" {
  name                = "example-bastion"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastionip.id
  }
}

