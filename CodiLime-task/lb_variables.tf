resource "azurerm_lb" "lb" {
    name                = var.load_balancer
    location            = azurerm_resource_group.infra.location
    resource_group_name = azurerm_resource_group.infra.name
  
    frontend_ip_configuration {
      name                 = "lb-frontend"
      public_ip_address_id = azurerm_public_ip.linux.id
      #sku                  = "Standard"
      #zones                = ["1", "2", "3"]
    }
  }
  
resource "azurerm_lb_backend_address_pool" "pool" {
   loadbalancer_id     = azurerm_lb.lb.id
   name                = "backend-pool"
  }
  
  # Associate the NIC with the Backend Address Pool
resource "azurerm_network_interface_backend_address_pool_association" "pool" {
   for_each = var.instances
   network_interface_id    = azurerm_network_interface.linux[each.key].id
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
  resource_group_name = azurerm_resource_group.infra.name
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Tcp"
  frontend_port       = each.value.frontend_port
  backend_port        = 22 #each.value.backend_port
  frontend_ip_configuration_name = "lb-frontend"
  #backend_address_pool_id        = azurerm_lb_backend_address_pool.pool.id
}