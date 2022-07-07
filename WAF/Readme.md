# Create a Web Application Firewall [WAF]

There are a lot resources that can be secured using WAF [Web application Firewall]. The WAF acts as proxy that takes all the traffic redirected to a resource and then redirect that traffic or block it based on the WAF policy pre-configured. The resources which can be secured by a WAF can be anything, from a simple static website, dynamic website, virtual machine, VM scale sets, Azure Kubernetes cluster, ...etc. 

By nature, every resource has its own configuration for the WAF. In here, I'm going to deploy a WAF to be ready for securing Kubernetes cluster in Azure [AKS]. There are many ways to deploy the any resource in Azure:-

i. Azure Portal
ii. Azure PowerShell
iii. Azure CLI
iv. Azure Resource Manager [ARM]

This article describes the easiest way to deploy resources in Azure by using Azure CLI. 

To install Azure CLI, you can refer to this [link](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).

To use the following command, you need to use a Bash terminal in your computer. In case you use Windows OS, you can install Git bash on your PC to use the command from this [link](https://git-scm.com/downloads). Otherwise, you can use the command in PowerShell terminal, but in this case, you need to delete the reverse slashes because PowerShell does not understand the slashes.

Before creating an application gateway, you need to do two things before:-

i. Create a virtual network by which the application gateway will be associated, or in other words, will take IP address from its subnet. Or pick an existing virtual network, preferrably the one that hosts the backend server to avoid having to create peering with two virtual networks.

- Also take into consideration when creating the virtual networks to avoid creating the same subnet in the two networks, otherwise you will not be able to create network peering becase of the IP address range overlapping. Make sure each virtual network has its own subnet which does not overlap with any other network, in case you need to create peering now or in the future.

ii. Allocate a public IP address which will be configured in the frontend configuration of the application gateway.

### Create a virtual Network

     az network vnet create \
          --name WAF-VNET \
          --resource-group rg-waf \
          --location germanywestcentral \
          --address-prefix 10.0.0.0/16 \
          --subnet-name myAGSubnet \
          --subnet-prefix 10.0.1.0/24

This will only work, if we already have a resource group with the name "rg-waf". If not, we need to create it before this step.


### Create a public IP address

The public IP address can be either static that will not change, or dynamic that can be changed automatically. In this case, it's better to pick static to make it easy to monitor the resource in the future.


     az network public-ip create \
          --resource-group rg-waf \
          --name waf-pip \
          --allocation-method Static \
          --sku Standard


### Create The Application Gateway

After creating the virtual network and allocating the public IP address required for the application gateway, now we go to create the application gateway itself.
We choose the "sku" to be WAF_V2 instead of Standard_V2 since we are creating a WAF. The WAF_V2 tier can be attached to a WAF policy which contains the rules we use to sift through the traffic before redirecting the traffic to the backend pool, whereas the Standard_V2 cannot be attached to a WAF policy.


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
       --public-ip-address waf-pip






