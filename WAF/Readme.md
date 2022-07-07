# Create an application gateway

There are a lot resources that can be secured using WAF [Web application Firewall]. The WAF acts as proxy that takes all the traffic redirected to a resource and then redirect that traffic or block it based on the WAF policy pre-configured. The resources which can be secured by a WAF can be anything, from a simple static website, dynamic website, virtual machine, VM scale sets, Azure Kubernetes cluster, ...etc. 

By nature, every resource has its own configuration for the WAF. In here, I'm going to deploy a WAF to be ready for securing Kubernetes cluster in Azure [AKS]. There are many ways to deploy the any resource in Azure:-

i. Azure Portal
ii. Azure PowerShell
iii. Azure CLI
iv. Azure Resource Manager [ARM]

This article describes the easiest way to deploy resources in Azure by using Azure CLI. 

### Create The Application Gateway

     az network application-gateway create \
       --name WAF-AKS \
       --location uaenorth \
       --resource-group rg-privateendpoint-uae \
       --vnet-name rg-privateendpoint-uae-vnet \
       --subnet myAGsubnet \
       --capacity 2 \
       --sku WAF_v2 \
       --http-settings-cookie-based-affinity Disabled \
       --frontend-port 80 \
       --http-settings-port 80 \
       --http-settings-protocol Http \
       --public-ip-address waf-aks-pip



