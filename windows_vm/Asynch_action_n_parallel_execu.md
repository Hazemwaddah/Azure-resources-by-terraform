Sure, let's delve into these topics:

**Asynchronous Actions in Ansible:**
By default, Ansible runs tasks synchronously, holding the connection to the remote node open until the action is completed. This means within a playbook, each task blocks the next task by default, meaning subsequent tasks will not run until the current task completes¹. 

Asynchronous mode in Ansible allows you to control how long-running tasks execute. You can run long-running operations in the background and check their status later¹. For example, to execute a long-running operation asynchronously in the background, with a timeout of 3600 seconds ( -B ), and without polling ( -P ), you can use:

```bash
ansible all -B 3600 -P 0 -a "/usr/bin/long_running_operation --do-stuff"
```

If you want to check on the job status later, you can use the `async_status` module, passing it the job ID that was returned when you ran the original job in the background¹.

**Parallel Execution Strategies in Ansible:**
Strategies are a way to control play execution. By default, plays run with a linear strategy, in which all hosts will run each task before any host starts the next task, using the number of forks (default 5) to parallelize⁶.

Ansible offers other strategies, including the `free` strategy, which allows each host to run until the end of the play as fast as it can⁶. You can select a different strategy for each play or set your preferred strategy globally in `ansible.cfg`⁶.

For example, if you want to manage only a few machines at a time during a rolling update, you can define how many hosts Ansible should manage at a single time using the `serial` keyword⁶.

Remember that these are advanced features of Ansible and should be used with care. Always test your playbooks thoroughly before running them in production.

Source: Conversation with Bing, 10/7/2023
(1) Asynchronous actions and polling — Ansible Documentation. https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_async.html.
(2) Controlling playbook execution: strategies and more - Ansible Documentation. https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html.
(3) Asynchronous Actions and Polling — Ansible Documentation. https://docs.ansible.com/ansible/2.9/user_guide/playbooks_async.html.
(4) How to handle long-running tasks in Ansible/Ansible Asynchronous .... https://medium.com/@cj86111088/how-to-handle-long-running-tasks-in-ansible-ansible-asynchronous-actions-and-polling-9a5c16825cd7.
(5) How to handle long-running tasks in Ansible/ Ansible Asynchronous .... https://devopswithcj.hashnode.dev/how-to-handle-long-running-tasks-in-ansible-ansible-asynchronous-actions-and-polling.
(6) Understanding Asynchronous Tasks in Ansible - Pluralsight. https://www.pluralsight.com/resources/blog/cloud/asynchronous-tasks-in-ansible.
(7) Strategies — Ansible Documentation. https://docs.ansible.com/ansible/2.8/user_guide/playbooks_strategies.html.
(8) Parallel Playbook Execution In Ansible | by İbrahim Gündüz - Medium. https://medium.com/developer-space/parallel-playbook-execution-in-ansible-30799ccda4e0.
(9) Does Ansible manages all hosts in parallel or just five? (-f and .... https://stackoverflow.com/questions/54077230/does-ansible-manages-all-hosts-in-parallel-or-just-five-f-and-serial.