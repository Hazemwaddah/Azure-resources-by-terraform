resource "azurerm_lb" "lb" {
    name                = var.load_balancer
    location            = var.location
    resource_group_name = var.resource_group_name
  
    frontend_ip_configuration {
      name                 = "lb-frontend"
      public_ip_address_id = azurerm_public_ip.pip.id
      #sku                  = "Standard"
      #zones                = ["1", "2", "3"]
    }
  }

resource "azurerm_public_ip" "pip" {
  name                = "public-ip"
  location            = var.location 
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_lb_backend_address_pool" "pool" {
   loadbalancer_id     = azurerm_lb.lb.id
   name                = "backend-pool"
  }



  # Associate the NIC with the Backend Address Pool
resource "azurerm_network_interface_backend_address_pool_association" "pool" {
   #for_each = var.linux_network_interface_id
   for_each = toset([
   "/subscriptions/2082bb2a-22e8-46c6-a2c7-63d706da03a0/resourceGroups/azure_testing_environment/providers/Microsoft.Network/networkInterfaces/instance1-nic",
   "/subscriptions/2082bb2a-22e8-46c6-a2c7-63d706da03a0/resourceGroups/azure_testing_environment/providers/Microsoft.Network/networkInterfaces/instance2-nic"
   ])
   network_interface_id    = each.value
   ip_configuration_name   = var.linux_ip_configuration_name
   backend_address_pool_id = azurerm_lb_backend_address_pool.pool.id
}    

resource "azurerm_lb_rule" "rule" {
  for_each = var.rules

  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LBRule-${each.key}"
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = "lb-frontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.pool.id]
  probe_id                       = azurerm_lb_probe.probe[each.key].id
}

resource "azurerm_lb_probe" "probe" {
  for_each = var.rules

  loadbalancer_id       = azurerm_lb.lb.id
  name                  = "${each.key}-running-probe"
  port                  = each.value.frontend_port
  protocol              = each.value.protocol
}

resource "azurerm_lb_nat_rule" "natrule" {
  for_each            = var.nat_rules
  
  name                = "${each.key}-ssh"
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Tcp"
  frontend_port       = each.value.frontend_port
  backend_port        = 22 #each.value.backend_port
  frontend_ip_configuration_name = "lb-frontend"
  #backend_address_pool_id        = azurerm_lb_backend_address_pool.pool.id
}