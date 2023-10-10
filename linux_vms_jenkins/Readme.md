
## Create a linux-vm that has Jenkins installed to deploy Continuous Integration (CI)


 This vm runs on Ubuntu linux "18.04-LTS" and will configured by running the attached 
 Ansible playbook. It's important to run this ansible playbook the first time as "root". This means you 
 need to hash "#" those two lines:



    '- name: linux Install Apache2, Java, MySQL, nginx, python3, docker and npm on linux-server
    hosts: linux-server
    vars:
        ansible_user: "adminuser"
        ansible_password: "P@ssw0rd123!"
    tasks:
        - name: Update APT package manager repositories cache'



#### Why is this?

This is because the first time you run this ansible playbook you need to install the fingerprint of this vm and that needs to be done with root user. 


    'The authenticity of host '20.21.103.125 (20.21.103.125)' can't be established.
    ED25519 key fingerprint is SHA256:Kyyo62HvnhUXUncHE/EeHfiOT7aCdjJKcfaJrYPF1UM.
    This key is not known by any other names
    Are you sure you want to continue connecting (yes/no/[fingerprint])? yes'

After this you will not be able to run ansible playbook without the user and password, and it'll give the following error:


    'TASK [Gathering Facts] *********************************************************
    fatal: [linux_host]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: Warning: Permanently added '20.21.103.125' (ED25519) to the list of known hosts.\r\nroot@20.21.103.125: Permission denied (publickey,password).", "unreachable": true}'


You then need to uncomment both username and password to be able to run this ansible playbook.

#### Security issue:

Note that creating a vm with a username and password is not the best security. There is a better way of authenticating a vm by creating an ssh key. However, for the sake of ease, I'll be using a username and password.

Also, note that using a hard-coded username and password poses another security issue as this file can be shared with others. Another alternative is by using Ansible vault, which I'll be talking about in another article in this repo.


#### Jenkins installation:

You can run the attached ansible playbook which will install Java and Jenkins. when you run the following code through ansible playbook, you will be faced with the following error:

TASK [Gathering Facts] *********************************************************
fatal: [linux_host]: FAILED! => {"msg": "Using a SSH password instead of a key is not possible because Host Key checking is enabled and sshpass does not support this.  Please add this host's fingerprint to your known_hosts file to manage this host."}


##### The explanation of this error:

This error happens because linux doesn't trust the GPG key for the repository of Jenkins and cannot verify its signature. Hence, it gives the below error:


    'The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 5BA31D57EF5975CA", "E: The repository 'http://pkg.jenkins.io/debian-stable binary/ Release' is not signed."]'


##### How to solve this:

Clearly, we need to enable linux to trust Jenkins repository signature, and we can to that through adding "[trusted=yes]" to the line of the wget command as you can see in the following part in the ansible playbook:


    '- name: Add Jenkins repo key
      become: yes
      shell: |
        wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
        echo deb [trusted=yes] http://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
        sudo apt-get update'


Now it's going to work, however it's not going to be the best practice since we are allowing linux to trust on non-verified repository signature that may pose a security issue, and this should be only used through testing environment not production.


