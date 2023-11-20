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

