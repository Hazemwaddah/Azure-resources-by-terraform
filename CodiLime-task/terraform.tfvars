location = "Qatar Central"
resource_group_name = "azure_testing_environment"
virtual_network_name = "my_virtual_network"
load_balancer = "lb"
subnet_name = "my_subnet"
control_vm_ip = "41.42.234.196"
private_key_file = "~/Github/Azure_Resources/CodiLime-task/Codi_key"
public_key_file  = "~/Github/Azure_Resources/CodiLime-task/Codi_key.pub"
availability_set_id = "/subscriptions/2082bb2a-22e8-46c6-a2c7-63d706da03a0/resourceGroups/azure_testing_environment/providers/Microsoft.Compute/availabilitySets/avset"
linux_network_interface_name = "linux-nic"
linux_ip_configuration_name = "linux-ip-config"
linux_vm_name = "linux-server-vm"
linux_vm_size = "Standard_B2s"
linux_image_publisher = "Canonical"
linux_image_offer = "UbuntuServer"
linux_image_sku = "18.04-LTS"
linux_image_version = "latest"
linux_admin_username = "adminuser"

#    resource_group_name = var.resource_group_name
#    location = module.vm.location
#    public_ip = module.load_balancer.pub_ip    