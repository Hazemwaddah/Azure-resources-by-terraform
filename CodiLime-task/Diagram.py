from diagrams import Diagram, Cluster
from diagrams.azure.compute import VM
from diagrams.azure.network import LoadBalancers, VirtualNetworks, NetworkSecurityGroupsClassic

with Diagram("Azure Architecture"):
    with Cluster("Resource Group"):
        vnet = VirtualNetworks("Virtual Network")
        vm = VM("Virtual Machine")
        lb = LoadBalancers("Load Balancer")
        nsg = NetworkSecurityGroupsClassic("NSG")

    vnet - vm - nsg - lb
    #vm - nsg
    #vm - lb
