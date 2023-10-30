## Create a vm Linux machine to deploy a stateless containerized application

This repo contains Terraform file deploy a Linux virtual machine that can host a stateless containerized application using Docker. Through out this article, you will find explanation of the security measures taken through the creation of the whole environment through Terraform code. 

### Options of deployment

There are multiple choices of infrastructure to deploy this stateless containerized application. 

First, we can use virtual machines that will host the web application, normally LinuxOS would be used in that case. Of course, in that case we will have to take into consideration applying the security counter measures needed to prevent unauthorized access and this is the scope of this article.

Second option, is to deploy Kubernetes cluster, for example in Azure we will deploy AKS. Using this option, we will build a repository and push the containerized image of this application into it. After this, we will configure AKS to pull the image from the repo and deployed automatically on its nodes

### Deployment procedure

It all starts by creating Terraform file that contains the infrastructure. A good practice is not to use a one Terraform file because it will be so complex for maintenance or modifications. Hence we will create multiple Terraform files and name them with the component of the environment that they contain. Below will be the list of the Terraform files as described:

1. vm.tf
This file will contain one or in our case multiple virtual machine that will host the web application. Then that file are used [for_each] Terraform function avoid enlarging the file. This makes it easy to add other virtual machine to be used in another environment, for example.

I also wrote the Terraform code in a way to add as much variables as I can to make it very easy to change for example the name of the virtual machine, size of the vms, OS version, .. etc.

2. lb.tf
This file contains the configuration for the deployment of a load balancer in Azure. Also, I put as much variables as I could. Furthermore, the configuration of the load balancer such as the prompt to end configuration, the back-end pool, the load balancing rules, and the NAT rules are contained into the file so as just as it is created it will work automatically.

3. nsg.tf
This file is for the network security group which enforces the security of the virtual network that contains the virtual machines hosting the application. More explanation of this in the nsg section.

4. rg.tf
For the sake of simplicity, I separated the resource group with the provider in the Terraform into a separate file. Also, made as variable in order to change the location easily.

5. variables.tf
This file contains the declaration of the variables in the Terraform code, but not the exact value. 

6. variables.tfvar
This file contains the exact value I added such as the location of the resource group, size of the vms, ...etc.


Using such approach is quite important for the ease of modification of the code whether to add different resources or re-use the code to create a whole different environment.


## Security


### Using SSH key pair in stead of (username and password)

Although we can create a virtual machine using username and a password, this may put potential security risks because we hard code both username and password into the Terraform code. Normally, this is a bad practice and should never be done.

However, there are many workarounds to enforce security into that scenarios. One of those is to create a Vault in which we inserts the password of the virtual machine.

As we learn from the security professional, passwords are not the best in enforcing security. One method to add the new the risk is the usage of SSH keys. SSH key authentication is built upon public key infrastructure [PKI] to add a secure layer for authentication and that is the best way to authenticate to a linux-based virtual machine.

In the first comments in the repo, I used username and password and then I replaced the password with the usage of ssh key to add more security.

A file named tls.tf was created to create rsa keys that will be used as ssh keys in the authentication process using Terraform, however the best practice is to generate the rsa keys outside of Terraform. This means it will be done manually and add the key through Terraform file, and this is the case.


### NSG

In order to to secure access to the web application infrastructure, a network security group should be placed before the virtual machine. Network security groups do an imperative job which is filter all the traffic [inbound/outbound]. This can be done through the creation and modification of sg to allow or deny access to a certain protocol such as ssh, ftp, ...etc.

UTILIZATION (NSG) meets the objective of enforcing virtual network security for the web application hosting virtual machine. One of the things that network security groups do is limiting the access to virtual machines to a specific IP address which is the IP of the control machine. This means that even though someone could bypass the other security measures tries to connect to the machine will not be able to connect.

![Alt text](image-2.png)

### Load balancer

One of the most significant security counter measures to consider when deploying the web application is to put the web application infrastructure, which in our case it is a virtual machine/multiple virtual machines, behind a load balancer. The load balancer has to important goals the first one is removing the public access to virtual machine and that is important. This means that the virtual machines will not have a public IP, hence there is no way to connect to them directly.

The second goal of deploying a load balancer is to/the traffic between multiple virtual machine instead of using only. Also, in case one of the virtual machines crashes the load balancer will route the traffic to the other virtual machine automatically, meaning no manual actions needed from DevOps engineer.

####  NAT rules

Those rules are very different from the load balancing rules.  The main difference between them is that load balancing rules do not differentiate between the virtual machines before routing the traffic to them, whereas the NAT rules gives us the ability to connect to a specific virtual machine behind the load balancer. Hence, these rule are created to be able to connect through ssh to each virtual machine on different ports.

As you can see from the figure below each virtual machine uses a different port. One machine uses port 3000 as the front-end port and the other uses port 3001. Those ports are the front-end ports of the load balancer which receives the traffic coming one of these ports and then transform that into port 22, the default port for ssh. This way the administrative port 22 is not exposed to the internet or public network which is an important security counter measure.

![Alt text](image-3.png)


Unfortunately, there is a limitation to the usage of NAT rules. As there is no way to automatically assign the target virtual machine to the NAT rule through Terraform; this has to be done manually each time after the creation of the NAT rule. There is no parameter or attribute in the Terraform code to insert the target system beforehand.


## Instructions


Now after going through the Terraform files, understanding the code now is the time to modify those files to give get the values that we want to have in our environment.

The developer will start by opening the variables.tfvar file to edit the values of the variables declared through Terraform file. As we can see from the image below those values can be changed to the values that we need. One example is important to take care of it which is the "control_vm_ip" variable, we can add the the value of the IP address of the machine that will have administrative access to those machine.

In addition, as mentioned above the best practice is to create the SSH key outside Terraform and then put the the path that contains those files [the key] as a variable as you can see in the below image:

![Alt text](image.png)


## Note


1. When creating the NAT rules from the beginning the "remote-exec" module will not work due to limitations of NAT rules.
NAT rules differ from load balancing rules. They are designed to give access to a specific machine behind the load balancer to be done manually, Hence, they reject/block the "remote-exec" module from installing docker service and running the docker container image automatically.

Creating a load balancing rule at the beginning using the Terraform code will utilize port 22. Therefore, when we try to create the NAT rules we will be faced with an issue because port 22 is already occupied with the load balancing so there is a conflict between load balancing rules and NAT rules. Hence, we will have to delete the load balancing group by removing them from the Terraform code and applying these changes again so the NAT rules will utilize port 22 at the back end.

While the back-end port is still the default one for SSH which is port 22, the front-end that will utilize are different as you can see from the image one machine is using port 3000 and another is using port 3001This is an important security counter measure when malicious attack or tries to ports can IP address they cannot find port 22 open so they don't know if the machine are Linux or not.


By hashing the load balancer from the Terraform file as we can see in the image below, and applying the changes using the command:

`terraform apply`


This will lead to deleting load balancer rules, and after that we can run the same command again to create the NAT


![Alt text](image-1.png)


2. Load balancers in Azure cannot have virtual machines in the backend pool unless they belong to the same availability zone. So I create availability zone to make sure all the virtual machines that have to be created through Terraform or in the same availability zone. This is extremely important.


3. There are more options that can be implemented to add mail or security the way administer our virtual machine. VPN is that choice. VPN provide security by encrypting all the traffic between the two parties. This prevents the interception of the traffic prom of third party, however that comes at a price which requires cost. For example, a VPM gateway needs to be add to Terraform infrastructure which is going to increase the cost. In addition to this, a certificate to be purchased a certificate authority CA. 

4. Another solution can be added to this infrastructure to provide more efficient high availability and that would be the deployment of "bastion". Bastion is a native-cloud service provided by Microsoft Cloud Azure. It is based on another cloud-native service that is called virtual machine-scale sets. VMSS service deploys multiple virtual machines in the back-end, but they are administered as a single virtual machine. Again, it comes with more cost.


5. If I am using another scenario to deploy the virtual machines using username and password, in that case and if I want to remains secure, I can create the key vault in Azure and that vault will contain the password. In this scenario, I will have to give the virtual machines access to this vault to retrieve the password so I will use managed identity/service principal in Azure. In one scenario, I will create a user-assigned managed identity and give access of "key-vault-secrets-user" role. This roles enables the virtual machines to read secrets from the key vault. After that, I will assign this user - assigned managed identity all virtual machine that is going to be created through Terraform code.


6. Securing web application can be implemented through the utilization of a web application firewall [WAF]. WAFs or specialized firewalls to prevent common web applications attacks such as cross-site scripting XSS, SQL injection, cross-site request forgery XSRF, ... etc. In Azure, we can deploy an application gateway and attach it to a WAF policy do the job of a WAF. Moreover, we can deploy a [frontdoor] which is another cloud-native service that deploys a WAF plus content-delivery networkCDN profile to improve the performance as well as security. Both aforementioned services are layer 7 services so they understand HTTP/HTTPS amongst other protocols, unlike layer for load balancer which doesn't. Again, this increases the cost of the network.


All of the above different services can be deployed depending on the exact need of each client. There is no one solution that fits all demands. 



## How to consume this repo

1. Clone the Repository: Clone the repository to your local machine using the command 

`git clone https://github.com/Hazemwaddah/azure-resources-by-terraform.git.`

2. Navigate to the Specific Folder: Use the command 

`cd azure-resources-by-terraform/CodiLime-task`

to navigate to the specific folder.

3. Pull the Latest Changes: Before starting your work, pull the latest changes from the repository using 

`git pull origin f1a6ca664d2a801d0fcebd9882699033451efdef.`

4. Create a New Branch: Create a new branch for your assignment using 

`git checkout -b <your_branch_name>`

5. Make Changes and Commit: After making changes to your code, add them to staging using 

`git add .`

then commit those changes using 

`git commit -m "<your_commit_message>"`

6. Push Your Changes: Push your changes to GitHub using 

`git push origin <your_branch_name>`


