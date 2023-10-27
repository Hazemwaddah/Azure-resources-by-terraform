########################################################################################################################

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

# Create a Health Probe    SSH
resource "azurerm_lb_probe" "sshprobe" {
  #resource_group_name   = azurerm_resource_group.infra.name
  loadbalancer_id       = azurerm_lb.lb.id
  name                  = "ssh-running-probe"
  port                  = 22
  protocol              = "Tcp"
}

# Create a Load Balancer Rule   SSH
resource "azurerm_lb_rule" "ssh" {
  #resource_group_name            = azurerm_resource_group.infra.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LBRule-ssh"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "lb-frontend"
  backend_address_pool_ids        = [azurerm_lb_backend_address_pool.pool.id]
  probe_id                       = azurerm_lb_probe.sshprobe.id
}

# Create a Health Probe     HTTP
resource "azurerm_lb_probe" "httprobe" {
  #resource_group_name   = azurerm_resource_group.infra.name
  loadbalancer_id       = azurerm_lb.lb.id
  name                  = "http-running-probe"
  port                  = 80
  protocol              = "Tcp"
}

# Create a Load Balancer Rule       HTTP
resource "azurerm_lb_rule" "http" {
  #resource_group_name            = azurerm_resource_group.infra.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LBRule-http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "lb-frontend"
  backend_address_pool_ids        = [azurerm_lb_backend_address_pool.pool.id]
  probe_id                       = azurerm_lb_probe.httprobe.id
}