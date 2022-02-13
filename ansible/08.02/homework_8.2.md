**1.** _Приготовьте свой собственный inventory файл `prod.yml`_:  
```yaml
---

elasticsearch:
  hosts:
    node01-elastic_yandex_cloud:
      ansible_host: 62.84.118.111
      ansible_connection: ssh
      ansible_user: centos

kibana:
  hosts:
    node02-kibana_yandex_cloud:
      ansible_host: 62.84.118.116
      ansible_connection: ssh
      ansible_user: centos
```
**2.** _Допишите `playbook`: нужно сделать ещё один `play`, который 
устанавливает и настраивает `kibana`_:  
```yaml
---

- name: Install Java
  hosts: all
  tasks:
    - name: Set facts for Java 11 vars
      set_fact:
        java_home: "/opt/jdk/{{ java_jdk_version }}"
      tags: java
    - name: Upload .tar.gz file containing binaries from local storage
      copy:
        src: "{{ java_oracle_jdk_package }}"
        dest: "/tmp/jdk-{{ java_jdk_version }}.tar.gz"
        mode: 0644
      register: download_java_binaries
      until: download_java_binaries is succeeded
      tags: java
    - name: Ensure installation dir exists
      become: true
      file:
        state: directory
        mode: 0644
        path: "{{ java_home }}"
      tags: java
    - name: Extract java in the installation directory
      become: true
      unarchive:
        copy: false
        src: "/tmp/jdk-{{ java_jdk_version }}.tar.gz"
        dest: "{{ java_home }}"
        extra_opts: [--strip-components=1]
        creates: "{{ java_home }}/bin/java"
      tags:
        - java
    - name: Export environment variables
      become: true
      template:
        src: jdk.sh.j2
        dest: /etc/profile.d/jdk.sh
        mode: 0644
      tags: java

- name: Install Elasticsearch
  hosts: elasticsearch
  tasks:
    - name: Upload tar.gz Elasticsearch from remote URL
      get_url:
        url: "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-{{ elastic_version }}-linux-x86_64.tar.gz"
        dest: "/tmp/elasticsearch-{{ elastic_version }}-linux-x86_64.tar.gz"
        mode: 0755
        timeout: 60
        force: true
        validate_certs: false
      register: get_elastic
      until: get_elastic is succeeded
      tags: elastic
    - name: Create directrory for Elasticsearch
      become: true
      file:
        state: directory
        path: "{{ elastic_home }}"
        mode: 0644
      tags: elastic
    - name: Extract Elasticsearch in the installation directory
      become: true
      unarchive:
        copy: false
        src: "/tmp/elasticsearch-{{ elastic_version }}-linux-x86_64.tar.gz"
        dest: "{{ elastic_home }}"
        extra_opts: [--strip-components=1]
        creates: "{{ elastic_home }}/bin/elasticsearch"
      tags:
        - elastic
    - name: Set environment Elastic
      become: true
      template:
        src: templates/elk.sh.j2
        dest: /etc/profile.d/elk.sh
        mode: 0644
      tags: elastic

- name: Install Kibana
  hosts: kibana
  tasks:
    - name: Upload tar.gz Kibana from remote URL
      get_url:
        url: "https://artifacts.elastic.co/downloads/kibana/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        dest: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        mode: 0755
        timeout: 60
        force: true
        validate_certs: false
      register: get_kibana
      until: get_kibana is succeeded
      tags: kibana
    - name: Create directrory for Kibana
      become: true
      file:
        state: directory
        path: "{{ kibana_home }}"
        mode: 0644
      tags: kibana
    - name: Extract Kibana in the installation directory
      become: true
      unarchive:
        copy: false
        src: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        dest: "{{ kibana_home }}"
        extra_opts: [--strip-components=1]
        creates: "{{ kibana_home }}/bin/kibana"
      tags:
        - kibana
    - name: Set environment Kibana
      become: true
      template:
        src: templates/kibana.sh.j2
        dest: /etc/profile.d/kibana.sh
        mode: 0644
      tags: kibana

```
**5.** _Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть_:  
```commandline
[jekis_@fedora playbook]$ ansible-lint site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
[jekis_@fedora playbook]$
```
Ошибок нет.  

**6.** _Попробуйте запустить `playbook` на этом окружении с флагом `--check`_:  
```commandline
[jekis_@fedora playbook]$ ansible-playbook -i inventory/prod.yml site.yml --check

PLAY [Install Java] ****************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [node01-elastic_yandex_cloud]
ok: [node02-kibana_yandex_cloud]

TASK [Set facts for Java 11 vars] **************************************************************************************************************************************
ok: [node01-elastic_yandex_cloud]
ok: [node02-kibana_yandex_cloud]

TASK [Upload .tar.gz file containing binaries from local storage] ******************************************************************************************************
changed: [node02-kibana_yandex_cloud]
changed: [node01-elastic_yandex_cloud]

TASK [Ensure installation dir exists] **********************************************************************************************************************************
changed: [node02-kibana_yandex_cloud]
changed: [node01-elastic_yandex_cloud]

TASK [Extract java in the installation directory] **********************************************************************************************************************
fatal: [node01-elastic_yandex_cloud]: FAILED! => {"changed": false, "msg": "dest '/opt/jdk/11.0.14' must be an existing dir"}
fatal: [node02-kibana_yandex_cloud]: FAILED! => {"changed": false, "msg": "dest '/opt/jdk/11.0.14' must be an existing dir"}

PLAY RECAP *************************************************************************************************************************************************************
node01-elastic_yandex_cloud : ok=4    changed=2    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
node02-kibana_yandex_cloud : ok=4    changed=2    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
```
**7.** _Запустите `playbook` на `prod.yml` окружении с флагом `--diff`. 
Убедитесь, что изменения на системе произведены_:  
```commandline
[jekis_@fedora playbook]$ ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Install Java] ****************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [node01-elastic_yandex_cloud]
ok: [node02-kibana_yandex_cloud]

TASK [Set facts for Java 11 vars] **************************************************************************************************************************************
ok: [node01-elastic_yandex_cloud]
ok: [node02-kibana_yandex_cloud]

TASK [Upload .tar.gz file containing binaries from local storage] ******************************************************************************************************
diff skipped: source file size is greater than 104448
changed: [node02-kibana_yandex_cloud]
diff skipped: source file size is greater than 104448
changed: [node01-elastic_yandex_cloud]

TASK [Ensure installation dir exists] **********************************************************************************************************************************
--- before
+++ after
@@ -1,5 +1,5 @@
 {
-    "mode": "0755",
+    "mode": "0644",
     "path": "/opt/jdk/11.0.14",
-    "state": "absent"
+    "state": "directory"
 }

changed: [node02-kibana_yandex_cloud]
--- before
+++ after
@@ -1,5 +1,5 @@
 {
-    "mode": "0755",
+    "mode": "0644",
     "path": "/opt/jdk/11.0.14",
-    "state": "absent"
+    "state": "directory"
 }

changed: [node01-elastic_yandex_cloud]

TASK [Extract java in the installation directory] **********************************************************************************************************************
changed: [node02-kibana_yandex_cloud]
changed: [node01-elastic_yandex_cloud]

TASK [Export environment variables] ************************************************************************************************************************************
--- before
+++ after: /home/jekis_/.ansible/tmp/ansible-local-27536l4j5r108/tmp3bigb33r/jdk.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export JAVA_HOME=/opt/jdk/11.0.14
+export PATH=$PATH:$JAVA_HOME/bin
\ No newline at end of file

changed: [node02-kibana_yandex_cloud]
--- before
+++ after: /home/jekis_/.ansible/tmp/ansible-local-27536l4j5r108/tmpa4uvp2_u/jdk.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export JAVA_HOME=/opt/jdk/11.0.14
+export PATH=$PATH:$JAVA_HOME/bin
\ No newline at end of file

changed: [node01-elastic_yandex_cloud]

PLAY [Install Elasticsearch] *******************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [node01-elastic_yandex_cloud]

TASK [Upload tar.gz Elasticsearch from remote URL] *********************************************************************************************************************
changed: [node01-elastic_yandex_cloud]

TASK [Create directrory for Elasticsearch] *****************************************************************************************************************************
--- before
+++ after
@@ -1,5 +1,5 @@
 {
-    "mode": "0755",
+    "mode": "0644",
     "path": "/opt/elastic/8.0.0",
-    "state": "absent"
+    "state": "directory"
 }

changed: [node01-elastic_yandex_cloud]

TASK [Extract Elasticsearch in the installation directory] *************************************************************************************************************
changed: [node01-elastic_yandex_cloud]

TASK [Set environment Elastic] *****************************************************************************************************************************************
--- before
+++ after: /home/jekis_/.ansible/tmp/ansible-local-279090zffchg8/tmpjhut8kvm/elk.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export ES_HOME=/opt/elastic/8.0.0
+export PATH=$PATH:$ES_HOME/bin
\ No newline at end of file

changed: [node01-elastic_yandex_cloud]

PLAY [Install Kibana] **************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [node02-kibana_yandex_cloud]

TASK [Upload tar.gz Kibana from remote URL] ****************************************************************************************************************************
changed: [node02-kibana_yandex_cloud]

TASK [Create directrory for Kibana] ************************************************************************************************************************************
--- before
+++ after
@@ -1,5 +1,5 @@
 {
-    "mode": "0755",
+    "mode": "0644",
     "path": "/opt/kibana/8.0.0",
-    "state": "absent"
+    "state": "directory"
 }

changed: [node02-kibana_yandex_cloud]

TASK [Extract Kibana in the installation directory] ********************************************************************************************************************
changed: [node02-kibana_yandex_cloud]

TASK [Set environment Kibana] ******************************************************************************************************************************************
--- before
+++ after: /home/jekis_/.ansible/tmp/ansible-local-28608be3r1cjl/tmpcfd8jbl3/kibana.sh.j2
@@ -0,0 +1,4 @@
+#!/usr/bin/env bash
+
+export KIB_HOME=/opt/kibana/8.0.0
+export PATH=$PATH:$KIB_HOME/bin

changed: [node02-kibana_yandex_cloud]

PLAY RECAP *************************************************************************************************************************************************************
node01-elastic_yandex_cloud : ok=10   changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
node02-kibana_yandex_cloud : ok=10    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
**8.** _Повторно запустите playbook с флагом `--diff` и убедитесь, 
что playbook идемпотентен_:  
```commandline
[jekis_@fedora playbook]$ ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Install Java] ****************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [node01-elastic_yandex_cloud]
ok: [node02-kibana_yandex_cloud]

TASK [Set facts for Java 11 vars] **************************************************************************************************************************************
ok: [node01-elastic_yandex_cloud]
ok: [node02-kibana_yandex_cloud]

TASK [Upload .tar.gz file containing binaries from local storage] ******************************************************************************************************
ok: [node02-kibana_yandex_cloud]
ok: [node01-elastic_yandex_cloud]

TASK [Ensure installation dir exists] **********************************************************************************************************************************
ok: [node02-kibana_yandex_cloud]
ok: [node01-elastic_yandex_cloud]

TASK [Extract java in the installation directory] **********************************************************************************************************************
skipping: [node02-kibana_yandex_cloud]
skipping: [node01-elastic_yandex_cloud]

TASK [Export environment variables] ************************************************************************************************************************************
ok: [node02-kibana_yandex_cloud]
ok: [node01-elastic_yandex_cloud]

PLAY [Install Elasticsearch] *******************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [node01-elastic_yandex_cloud]

TASK [Upload tar.gz Elasticsearch from remote URL] *********************************************************************************************************************
ok: [node01-elastic_yandex_cloud]

TASK [Create directrory for Elasticsearch] *****************************************************************************************************************************
ok: [node01-elastic_yandex_cloud]

TASK [Extract Elasticsearch in the installation directory] *************************************************************************************************************
skipping: [node01-elastic_yandex_cloud]

TASK [Set environment Elastic] *****************************************************************************************************************************************
ok: [node01-elastic_yandex_cloud]

PLAY [Install Kibana] **************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [node02-kibana_yandex_cloud]

TASK [Upload tar.gz Kibana from remote URL] ****************************************************************************************************************************
ok: [node02-kibana_yandex_cloud]

TASK [Create directrory for Kibana] ************************************************************************************************************************************
ok: [node02-kibana_yandex_cloud]

TASK [Extract Kibana in the installation directory] ********************************************************************************************************************
skipping: [node02-kibana_yandex_cloud]

TASK [Set environment Kibana] ******************************************************************************************************************************************
ok: [node02-kibana_yandex_cloud]

PLAY RECAP *************************************************************************************************************************************************************
node01-elastic_yandex_cloud : ok=9    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
node02-kibana_yandex_cloud : ok=9    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
```
Данный `playbook` идемпотентен.