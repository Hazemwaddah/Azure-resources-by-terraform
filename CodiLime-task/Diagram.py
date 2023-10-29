from diagrams import Diagram, Cluster
from diagrams.azure.compute import VM
from diagrams.azure.network import LoadBalancers, VirtualNetworks, NetworkSecurityGroupsClassic, PublicIpAddresses

with Diagram("Azure Architecture"):
    with Cluster("Resource Group"):
        vnet = VirtualNetworks("Virtual Network")
        vm1 = VM("Virtual Machine 1")
        vm2 = VM("Virtual Machine 2")
        lb = LoadBalancers("Load Balancer")
        nsg1 = NetworkSecurityGroupsClassic("NSG 1")
        nsg2 = NetworkSecurityGroupsClassic("NSG 2")
        pip = PublicIpAddresses("Public IP")

    vm1 - nsg1 - lb - pip
    vm2 - nsg2 - lb - pip

