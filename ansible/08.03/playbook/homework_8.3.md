**1.** _Допишите playbook: нужно сделать ещё один play, который 
устанавливает и настраивает kibana_:  
```yaml
- name: Install Kibana
  hosts: kibana
  handlers:
    - name: restart Kibana
      become: true
      service:
        name: kibana
        state: restarted
  tasks:
    - name: "Download Kibana's rpm"
      get_url:
        url: "https://artifacts.elastic.co/downloads/kibana/kibana-{{ elk_stack_version }}-x86_64.rpm"
        dest: "/tmp/kibana-{{ elk_stack_version }}-x86_64.rpm"
      register: download_kibana
      until: download_kibana is succeeded
    - name: Install Kibana
      become: true
      yum:
        name: "/tmp/kibana-{{ elk_stack_version }}-x86_64.rpm"
        state: present
    - name: Configure Kibana
      become: true
      template:
        src: kibana.sh.j2
        dest: /etc/profile.d/kibana.sh
        mode: 0755
      notify: restarted Kibana
```
**2.** _Приготовьте свой собственный inventory файл `prod.yml`_:  
```yaml
elasticsearch:
  hosts:
    node01-elastic_yandex_cloud:
      ansible_host: 51.250.12.84
      ansible_connection: ssh
      ansible_user: centos

kibana:
  hosts:
    node02-kibana_yandex_cloud:
      ansible_host: 62.84.118.13
      ansible_connection: ssh
      ansible_user: centos
```
**3.** _Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть_:  
```commandline
[root@fedora playbook]# ansible-lint site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
```
Ошибок нет.  

**4.** _Попробуйте запустить playbook на этом окружении с флагом `--check`_:  
```commandline
[root@fedora playbook]# ansible-playbook -i inventory/prod/hosts.yml site.yml --check

PLAY [Install Java] ****************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [node02-kibana_yandex_cloud]
ok: [node01-elastic_yandex_cloud]

TASK [Install Java] ****************************************************************************************************************************************************
changed: [node02-kibana_yandex_cloud]
changed: [node01-elastic_yandex_cloud]

PLAY [Install Elasticsearch] *******************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [node01-elastic_yandex_cloud]

TASK [Download Elasticsearch's rpm] ************************************************************************************************************************************
changed: [node01-elastic_yandex_cloud]

TASK [Install Elasticsearch] *******************************************************************************************************************************************
fatal: [node01-elastic_yandex_cloud]: FAILED! => {"changed": false, "msg": "No RPM file matching '/tmp/elasticsearch-8.0.1-x86_64.rpm' found on system", "rc": 127, "results": ["No RPM file matching '/tmp/elasticsearch-8.0.1-x86_64.rpm' found on system"]}

PLAY RECAP *************************************************************************************************************************************************************
node01-elastic_yandex_cloud : ok=4    changed=2    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
node02-kibana_yandex_cloud : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
**5.** _Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, 
что изменения на системе произведены_:  
```commandline
[root@fedora playbook]# ansible-playbook -i inventory/prod/hosts.yml site.yml --diff

PLAY [Install Java] ****************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [node02-kibana_yandex_cloud]
ok: [node01-elastic_yandex_cloud]

TASK [Install Java] ****************************************************************************************************************************************************
ok: [node02-kibana_yandex_cloud]
ok: [node01-elastic_yandex_cloud]

PLAY [Install Elasticsearch] *******************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [node01-elastic_yandex_cloud]

TASK [Download Elasticsearch's rpm] ************************************************************************************************************************************
ok: [node01-elastic_yandex_cloud]

TASK [Install Elasticsearch] *******************************************************************************************************************************************
changed: [node01-elastic_yandex_cloud]

TASK [Configure Elasticsearch] *****************************************************************************************************************************************
--- before: /etc/elasticsearch/elasticsearch.yml
+++ after: /root/.ansible/tmp/ansible-local-10270jafhqgds/tmprxrm7b9f/elasticsearch.yml.j2
@@ -1,82 +1,7 @@
-# ======================== Elasticsearch Configuration =========================
-#
-# NOTE: Elasticsearch comes with reasonable defaults for most settings.
-#       Before you set out to tweak and tune the configuration, make sure you
-#       understand what are you trying to accomplish and the consequences.
-#
-# The primary way of configuring a node is via this file. This template lists
-# the most important settings you may want to configure for a production cluster.
-#
-# Please consult the documentation for further information on configuration options:
-# https://www.elastic.co/guide/en/elasticsearch/reference/index.html
-#
-# ---------------------------------- Cluster -----------------------------------
-#
-# Use a descriptive name for your cluster:
-#
-#cluster.name: my-application
-#
-# ------------------------------------ Node ------------------------------------
-#
-# Use a descriptive name for the node:
-#
-#node.name: node-1
-#
-# Add custom attributes to the node:
-#
-#node.attr.rack: r1
-#
-# ----------------------------------- Paths ------------------------------------
-#
-# Path to directory where to store the data (separate multiple locations by comma):
-#
 path.data: /var/lib/elasticsearch
-#
-# Path to log files:
-#
 path.logs: /var/log/elasticsearch
-#
-# ----------------------------------- Memory -----------------------------------
-#
-# Lock the memory on startup:
-#
-#bootstrap.memory_lock: true
-#
-# Make sure that the heap size is set to about half the memory available
-# on the system and that the owner of the process is allowed to use this
-# limit.
-#
-# Elasticsearch performs poorly when the system is swapping the memory.
-#
-# ---------------------------------- Network -----------------------------------
-#
-# By default Elasticsearch is only accessible on localhost. Set a different
-# address here to expose this node on the network:
-#
-#network.host: 192.168.0.1
-#
-# By default Elasticsearch listens for HTTP traffic on the first free port it
-# finds starting at 9200. Set a specific HTTP port here:
-#
-#http.port: 9200
-#
-# For more information, consult the network module documentation.
-#
-# --------------------------------- Discovery ----------------------------------
-#
-# Pass an initial list of hosts to perform discovery when this node is started:
-# The default list of hosts is ["127.0.0.1", "[::1]"]
-#
-#discovery.seed_hosts: ["host1", "host2"]
-#
-# Bootstrap the cluster using an initial set of master-eligible nodes:
-#
-#cluster.initial_master_nodes: ["node-1", "node-2"]
-#
-# For more information, consult the discovery and cluster formation module documentation.
-#
-# ---------------------------------- Various -----------------------------------
-#
-# Require explicit names when deleting indices:
-#
-#action.destructive_requires_name: true
+network.host: 0.0.0.0
+discovery.seed_hosts: ["192.168.101.5"]
+node.name: node-a
+cluster.initial_master_nodes: 
+   - node-a

changed: [node01-elastic_yandex_cloud]

RUNNING HANDLER [restart Elasticsearch] ********************************************************************************************************************************
changed: [node01-elastic_yandex_cloud]

PLAY [Install Kibana] **************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [node02-kibana_yandex_cloud]

TASK [Download Kibana's rpm] *******************************************************************************************************************************************
ok: [node02-kibana_yandex_cloud]

TASK [Install Kibana] **************************************************************************************************************************************************
changed: [node02-kibana_yandex_cloud]

TASK [Configure Kibana] ************************************************************************************************************************************************
ok: [node02-kibana_yandex_cloud]

PLAY RECAP *************************************************************************************************************************************************************
node01-elastic_yandex_cloud : ok=7    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
node02-kibana_yandex_cloud : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
**6.** _Повторно запустите playbook с флагом `--diff` и убедитесь, 
что playbook идемпотентен_:  
```commandline
[root@fedora playbook]# ansible-playbook -i inventory/prod/hosts.yml site.yml --diff

PLAY [Install Java] ****************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [node02-kibana_yandex_cloud]
ok: [node01-elastic_yandex_cloud]

TASK [Install Java] ****************************************************************************************************************************************************
ok: [node02-kibana_yandex_cloud]
ok: [node01-elastic_yandex_cloud]

PLAY [Install Elasticsearch] *******************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [node01-elastic_yandex_cloud]

TASK [Download Elasticsearch's rpm] ************************************************************************************************************************************
ok: [node01-elastic_yandex_cloud]

TASK [Install Elasticsearch] *******************************************************************************************************************************************
ok: [node01-elastic_yandex_cloud]

TASK [Configure Elasticsearch] *****************************************************************************************************************************************
ok: [node01-elastic_yandex_cloud]

PLAY [Install Kibana] **************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [node02-kibana_yandex_cloud]

TASK [Download Kibana's rpm] *******************************************************************************************************************************************
ok: [node02-kibana_yandex_cloud]

TASK [Install Kibana] **************************************************************************************************************************************************
ok: [node02-kibana_yandex_cloud]

TASK [Configure Kibana] ************************************************************************************************************************************************
ok: [node02-kibana_yandex_cloud]

PLAY RECAP *************************************************************************************************************************************************************
node01-elastic_yandex_cloud : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node02-kibana_yandex_cloud : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
**7.** _Проделайте шаги с 1 до 8 для создания ещё одного play, 
который устанавливает и настраивает filebeat_:  
```yaml
- name: Install Filebeat
  hosts: filebeat
  handlers:
    - name: restart Filebeat
      become: true
      service:
        name: filebeat
        state: restarted
  tasks:
    - name: "Download Filebeat's rpm"
      get_url:
        url: "https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-{{ elk_stack_version }}-x86_64.rpm"
        dest: "/tmp/filebeat-{{ elk_stack_version }}-x86_64.rpm"
      register: download_filebeat
      until: download_filebeat is succeeded
    - name: Install Filebeat
      become: true
      yum:
        name: "/tmp/filebeat-{{ elk_stack_version }}-x86_64.rpm"
        state: present
    - name: Configure Filebeat
      become: true
      template:
        src: filebeat.yml.j2
        dest: /etc/filebeat/filebeat.yml
        mode: 0644
      notify: restarted Filebeat
```
```yaml
elasticsearch:
  hosts:
    node01-elastic_yandex_cloud:
      ansible_host: 51.250.5.99
      ansible_connection: ssh
      ansible_user: centos

kibana:
  hosts:
    node02-kibana_yandex_cloud:
      ansible_host: 62.84.127.20
      ansible_connection: ssh
      ansible_user: centos

filebeat:
  hosts:
    node03-filebeat_yandex_cloud:
      ansible_host: 62.84.113.22
      ansible_connection: ssh
      ansible_user: centos
```
```commandline
[root@fedora playbook]# ansible-lint file.yaml 
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: file.yaml
```
```commandline
[root@fedora playbook]# ansible-playbook -i inventory/prod/hosts.yml file.yaml --check

PLAY [Install Filebeat] ************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [node03-filebeat_yandex_cloud]

TASK [Download Filebeat's rpm] *****************************************************************************************************************************************
changed: [node03-filebeat_yandex_cloud]

TASK [Install Filebeat] ************************************************************************************************************************************************
fatal: [node03-filebeat_yandex_cloud]: FAILED! => {"changed": false, "msg": "No RPM file matching '/tmp/filebeat-7.14.2-x86_64.rpm' found on system", "rc": 127, "results": ["No RPM file matching '/tmp/filebeat-7.14.2-x86_64.rpm' found on system"]}

PLAY RECAP *************************************************************************************************************************************************************
node03-filebeat_yandex_cloud : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
```
```commandline
[root@fedora playbook]# ansible-playbook -i inventory/prod/hosts.yml file.yaml --diff

PLAY [Install Filebeat] ************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [node03-filebeat_yandex_cloud]

TASK [Download Filebeat's rpm] *****************************************************************************************************************************************
changed: [node03-filebeat_yandex_cloud]

TASK [Install Filebeat] ************************************************************************************************************************************************
changed: [node03-filebeat_yandex_cloud]

TASK [Configure Filebeat] **********************************************************************************************************************************************
ok: [node03-filebeat_yandex_cloud]

PLAY RECAP *************************************************************************************************************************************************************
node03-filebeat_yandex_cloud : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
```commandline
[root@fedora playbook]# ansible-playbook -i inventory/prod/hosts.yml file.yaml --diff

PLAY [Install Filebeat] ************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [node03-filebeat_yandex_cloud]

TASK [Download Filebeat's rpm] *****************************************************************************************************************************************
ok: [node03-filebeat_yandex_cloud]

TASK [Install Filebeat] ************************************************************************************************************************************************
ok: [node03-filebeat_yandex_cloud]

TASK [Configure Filebeat] **********************************************************************************************************************************************
ok: [node03-filebeat_yandex_cloud]

PLAY RECAP *************************************************************************************************************************************************************
node03-filebeat_yandex_cloud : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```