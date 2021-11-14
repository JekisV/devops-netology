1. *Опишите своими словами основные преимущества применения на 
практике IaaC паттернов*:  
**CI** - сокращение стоимости исправления дефекта, за счёт его раннего 
выявления, а так-же снижает трудозатраты при выполнении рутинных задач.  
**CDelivery** - позволяет выпускать изменения небольшими партиями, и в случаи
неисправности позволяет откатиться на предыдущие версии и последующего
перезапуска процесса сборки с учётом исправления выявленных дефектов.  
**CDeployment** - механизм непрерывного развёртывания упраздняет ручные 
действия, не требуя непосредственного утверждения со стороны разработчика
или любого другого ответственного лица, требует ручного подтверждения
запуска процесса.   


2. *Какой из принципов IaaC является основополагающим?* - цена, скорость 
и уменьшение рисков. Уменьшение расходов относится не только к финансовой 
составляющей, но и к количеству времени, затрачиваемого на рутинные 
операции. Принципы IaaC позволяют не фокусироваться на рутине, а заниматься
более важными задачами. Автоматизация инфраструктуры позволяет эффективнее 
использовать существующие ресурсы. Также автоматизация позволяет 
минимизировать риск возникновения человеческой ошибки.  


3. *Чем Ansible выгодно отличается от других систем управление
конфигурациями?* - нет необходимости устанавливать на удаленные узлы 
дополнительное ПО, код программы написан на питоне, что в свою очередь 
дает возможность как подключение дополнительных модулей, так и написание
собственных, язык написания ролей передельно прост.  


4. *Какой, на ваш взгляд, метод работы систем конфигурации более 
надёжный push или pull?* - думаю что **pull** метод будет являться более
надежным методом конфигурации, т.к. данный метод позволяет избежать дрейф
конфигураций на стенде (кластере).  


5. *Установить на личный компьютер: VirtualBox Vagrant Ansible.
Приложить вывод команд установленных версий каждой из программ:*  
```commandline
[root@fedora jekis_]# virtualbox --help
Oracle VM VirtualBox VM Selector v6.1.28_rpmfusion
[root@fedora jekis_]# vagrant -v
Vagrant 2.2.19
[root@fedora jekis_]# ansible --version
ansible 2.9.27
```

6. *Воспроизвести практическую часть лекции самостоятельно:*  
```commandline
[jekis_@fedora vagrant]$ vagrant up
Bringing machine 'server1.netology' up with 'virtualbox' provider...
==> server1.netology: Checking if box 'bento/ubuntu-20.04' version '202107.28.0' is up to date...
==> server1.netology: Clearing any previously set network interfaces...
==> server1.netology: Preparing network interfaces based on configuration...
    server1.netology: Adapter 1: nat
    server1.netology: Adapter 2: hostonly
==> server1.netology: Forwarding ports...
    server1.netology: 22 (guest) => 20011 (host) (adapter 1)
    server1.netology: 22 (guest) => 2222 (host) (adapter 1)
==> server1.netology: Running 'pre-boot' VM customizations...
==> server1.netology: Booting VM...
==> server1.netology: Waiting for machine to boot. This may take a few minutes...
    server1.netology: SSH address: 127.0.0.1:2222
    server1.netology: SSH username: vagrant
    server1.netology: SSH auth method: private key
    server1.netology: Warning: Connection reset. Retrying...
    server1.netology: Warning: Remote connection disconnect. Retrying...
    server1.netology: Warning: Connection reset. Retrying...
    server1.netology: Warning: Remote connection disconnect. Retrying...
    server1.netology: 
    server1.netology: Vagrant insecure key detected. Vagrant will automatically replace
    server1.netology: this with a newly generated keypair for better security.
    server1.netology: 
    server1.netology: Inserting generated public key within guest...
    server1.netology: Removing insecure key from the guest if it's present...
    server1.netology: Key inserted! Disconnecting and reconnecting using new SSH key...
==> server1.netology: Machine booted and ready!
==> server1.netology: Checking for guest additions in VM...
==> server1.netology: Setting hostname...
==> server1.netology: Configuring and enabling network interfaces...
==> server1.netology: Mounting shared folders...
    server1.netology: /vagrant => /home/jekis_/project/vagrant
==> server1.netology: Running provisioner: ansible...
    server1.netology: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [server1.netology]

TASK [Create directory for ssh-keys] *******************************************
changed: [server1.netology]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
changed: [server1.netology]

TASK [Checking DNS] ************************************************************
changed: [server1.netology]

TASK [Installing tools] ********************************************************
[DEPRECATION WARNING]: Invoking "apt" only once while using a loop via 
squash_actions is deprecated. Instead of using a loop to supply multiple items 
and specifying `package: "{{ item }}"`, please use `package: ['git', 'curl']` 
and remove the loop. This feature will be removed in version 2.11. Deprecation 
warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [server1.netology] => (item=['git', 'curl'])

TASK [Installing docker] *******************************************************
[WARNING]: Consider using the get_url or uri module rather than running 'curl'.
If you need to use command because get_url or uri is insufficient you can add
'warn: false' to this command task or set 'command_warnings=False' in
ansible.cfg to get rid of this message.
changed: [server1.netology]

TASK [Add the current user to docker group] ************************************
changed: [server1.netology]

PLAY RECAP *********************************************************************
server1.netology           : ok=7    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

[jekis_@fedora vagrant]$ vagrant ssh
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sun 14 Nov 2021 02:23:43 PM UTC

  System load:  0.58              Users logged in:          0
  Usage of /:   3.2% of 61.31GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 20%               IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                IPv4 address for eth1:    192.168.56.15
  Processes:    107


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Sun Nov 14 14:22:51 2021 from 10.0.2.2
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
vagrant@server1:~$
```