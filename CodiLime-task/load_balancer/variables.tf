
variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resources"
  type        = string
}


variable "load_balancer" {}
variable "linux_network_interface_name" {}
variable "linux_ip_configuration_name" {}

variable "linux_network_interface_id" {
  description = "The ID of the Linux network interface"
  #instance1 = "instance1-nic"
  #instance2 = "instance2-nic"
}


############################################################################################

# Load balancer variables

variable "rules" {
  description = "Map of rules to create"
  default = {
    #ssh = {
     # protocol = "Tcp"
     # frontend_port = 22
     # backend_port = 22
    #}
    http = {
      protocol = "Tcp"
      frontend_port = 80
      backend_port = 80
    }
  }
}

variable "nat_rules" {
  description = "Map of NAT rules"
  default = {
    rule1 = {
      name      = "ssh"
      frontend_port = 3000
      backend_port  = 22
      target_virtual_machine = "instance1-vm"
      target = "instance1-vm"
    }
    rule2 = {
      name      = "ssh"
      frontend_port = 3001
      backend_port  = 22
      target_virtual_machine = "instance2-vm"
    }  
  }
}


#variable "public_ip" {
#  description = "Public IP address of the VM"
#  type        = string
#}


variable "instances" {
  description = "The map of instances to create"
  default = {
    instance1 = "adminuser1"
    instance2 = "adminuser2"
  }
}