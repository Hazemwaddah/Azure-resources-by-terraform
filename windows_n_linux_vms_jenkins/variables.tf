# Global Variables

variable "location" {}
variable "client_id" {}
variable "client_secret" {}
variable "subscription_id" {}
variable "tenant_id" {}
variable "resource_group_name" {}
variable "virtual_network_name" {}
variable "subnet_name" {}
#variable "admin_username" {}
#variable "admin_password" {}
#variable "network_interface_name" {}
#variable "ip_configuration_name" {}

########################################################################################################################

# windows-server 

variable "windows_network_interface_name" {}
variable "windows_ip_configuration_name" {}
variable "windows_vm_name" {}
variable "windows_vm_size" {}
variable "windows_image_publisher" {}
variable "windows_image_sku" {}
variable "windows_image_version" {}
variable "windows_image_offer" {}
variable "windows_admin_username" {}
variable "windows_admin_password" {}

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
variable "linux_admin_password" {}
