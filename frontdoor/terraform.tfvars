location = "Qatar Central"
client_id = "your_client_id"
client_secret = "your_client_secret"
subscription_id = "2082bb2a-22e8-46c6-a2c7-63d706da03a0"
tenant_id = "87d51e3d-4129-4813-858a-03626891cec5"
resource_group_name = "azure_testing_environment"
virtual_network_name = "my_virtual_network"
subnet_name = "my_subnet"
#admin_username = "adminuser"
#admin_password = "P@ssw0rd123!"

##################################################################################################

####                  Linux vm

linux_network_interface_name = "linux-nic"
linux_ip_configuration_name = "linux-ip-config"
linux_vm_name = "linux-vm"
linux_vm_size = "Standard_B2s"
linux_image_publisher = "Canonical"
linux_image_offer = "UbuntuServer"
linux_image_sku = "18.04-LTS"
linux_image_version = "latest"
linux_admin_username = "adminuser"
linux_admin_password = "P@ssw0rd123!"

##################################################################################################

####                  front door

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


# address     = "linux-vm.qatarcentral.cloudapp.azure.com"
