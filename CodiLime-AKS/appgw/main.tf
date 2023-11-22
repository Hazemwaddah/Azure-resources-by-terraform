
resource "azurerm_application_gateway" "example" {
  name                = "waf-gw"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.waf_subnet
  }

  frontend_port {
    name = "my-frontend-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "my-frontend-ip-configuration"
    public_ip_address_id = var.wafip_id
    #public_ip_address_id = azurerm_public_ip.wafip.id
  }

  backend_address_pool {
    name = "my-backend-address-pool"
  }

  backend_http_settings {
    name                  = "my-backend-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = "my-http-listener"
    frontend_ip_configuration_name = "my-frontend-ip-configuration"
    frontend_port_name             = "my-frontend-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "my-request-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "my-http-listener"
    backend_address_pool_name  = "my-backend-address-pool"
    backend_http_settings_name = "my-backend-http-settings"
    priority                   = 1
  }
  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"

    disabled_rule_group {
      rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
    }

    file_upload_limit_mb = 100
    request_body_check   = true
    max_request_body_size_kb = 128
  }
}




####################################################################################################################

resource "azurerm_web_application_firewall_policy" "example" {
  name                = "wafpolicy"
  resource_group_name = var.resource_group_name
  location            = var.location


  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
      /*
      rule_group_override {
        rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
        disabled_rules  = ["920300", "920440"]
      } */
    }
  }

  custom_rules {
    name      = "Rule1"
    priority  = 1
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RemoteAddr"
      }

      operator           = "IPMatch"
      negation_condition = false
      match_values       = ["192.168.1.0/24", "10.0.0.0/24"]
    }

    action = "Block"
  }

  policy_settings {
    enabled = true
    mode    = "Prevention"
  }
}













####################################################################################################################


/*
resource "azurerm_frontdoor" "frontdoor" {
  name                = var.frontdoor_name
  resource_group_name = var.resource_group_name

  routing_rule {
    name               = var.routing_rule_name
    accepted_protocols = var.accepted_protocols
    patterns_to_match  = var.patterns_to_match
    frontend_endpoints = var.frontend_endpoints
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "exampleBackendBing"
    }
  }

  backend_pool_load_balancing {
    name = var.backend_pool_load_balancing_name
  }

  backend_pool_health_probe {
    name = var.backend_pool_health_probe_name
  }

  backend_pool {
    name = var.backend_pool_name
    backend {
      host_header = var.backend_host_header
      address     = var.backend_address
      http_port   = var.backend_http_port
      https_port  = var.backend_https_port
    }

    load_balancing_name = var.backend_pool_load_balancing_name
    health_probe_name   = var.backend_pool_health_probe_name
  }

  frontend_endpoint {
    name      = var.frontend_endpoint_name
    # host_name = var.frontend_endpoint_host_name             # only use with custom domain
    host_name = "${var.frontdoor_name}.azurefd.net"           # use with azure default domain
  }
}

*/