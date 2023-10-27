# Global Variables

variable "location" {}
variable "resource_group_name" {}
variable "virtual_network_name" {}
variable "subnet_name" {}
variable "load_balancer" {}
variable "control_vm_ip" {}
variable "private_key_file" {}
variable "public_key_file" {}
variable "instances" {
  description = "The map of instances to create"
  default = {
    instance1 = "adminuser1"
    instance2 = "adminuser2"
  }
}

#variable "admin_password" {
#  description = "The password of the admin account"
#  default     = "P@ssw0rd123!"
#}

########################################################################################################################

# linux-server 

variable "linux_network_interface_name" {}
variable "linux_ip_configuration_name" {}
variable "linux_vm_name" {}
variable "linux_vm_size" {}
variable "linux_image_publisher" {}
variable "linux_image_sku" {}
variable "linux_image_version" {}
variable "linux_image_offer" {}
variable "linux_admin_username" {}
#variable "linux_admin_password" {}
