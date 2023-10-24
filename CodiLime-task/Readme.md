#### Create avm Linux machine to deploy a stateless containerized application


This repo contains Terraform file deploy a Linux virtual machine that can host a stateless containerized application using Docker. First, we will create a virtual machine into all your and we are going to let Terraform run the script to install Docker and then deploy the Docker image, all automatically.

2. Another method to achieve the goal of this article is by creating a Linux machine using Terraform, yet this time we are going to use/run Ansible playbook to install Docker. However, this article scope is to focus on the first method by creating the Terraform and Uninstalling and deploying Docker application without running Ansible playbook, just by Terraform.

