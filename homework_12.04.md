### _Подготовить инвентарь kubespray_  
Новые тестовые кластеры требуют типичных простых настроек. 
Нужно подготовить инвентарь и проверить его работу. Требования к инвентарю:
* подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды;
* в качестве CRI — containerd;
* запуск etcd производить на мастере.  
---
При помощи **Terraform** развернул 5 нод в **YandexCloud**:  
```commandline
yandex_vpc_network.default: Creating...
yandex_vpc_network.default: Creation complete after 1s [id=enp8vtpbmjbg18u37k7n]
yandex_vpc_subnet.default: Creating...
yandex_vpc_subnet.default: Creation complete after 1s [id=e9bp0l6rrn10530ku2me]
yandex_compute_instance.slave-node-01: Creating...
yandex_compute_instance.slave-node-04: Creating...
yandex_compute_instance.master-node-01: Creating...
yandex_compute_instance.slave-node-02: Creating...
yandex_compute_instance.slave-node-03: Creating...
yandex_compute_instance.slave-node-01: Still creating... [10s elapsed]
yandex_compute_instance.master-node-01: Still creating... [10s elapsed]
yandex_compute_instance.slave-node-04: Still creating... [10s elapsed]
yandex_compute_instance.slave-node-02: Still creating... [10s elapsed]
yandex_compute_instance.slave-node-03: Still creating... [10s elapsed]
yandex_compute_instance.slave-node-01: Still creating... [20s elapsed]
yandex_compute_instance.slave-node-04: Still creating... [20s elapsed]
yandex_compute_instance.master-node-01: Still creating... [20s elapsed]
yandex_compute_instance.slave-node-02: Still creating... [20s elapsed]
yandex_compute_instance.slave-node-03: Still creating... [20s elapsed]
yandex_compute_instance.slave-node-01: Still creating... [30s elapsed]
yandex_compute_instance.slave-node-04: Still creating... [30s elapsed]
yandex_compute_instance.master-node-01: Still creating... [30s elapsed]
yandex_compute_instance.slave-node-02: Still creating... [30s elapsed]
yandex_compute_instance.slave-node-03: Still creating... [30s elapsed]
yandex_compute_instance.slave-node-01: Still creating... [40s elapsed]
yandex_compute_instance.master-node-01: Still creating... [40s elapsed]
yandex_compute_instance.slave-node-04: Still creating... [40s elapsed]
yandex_compute_instance.slave-node-02: Still creating... [40s elapsed]
yandex_compute_instance.slave-node-03: Still creating... [40s elapsed]
yandex_compute_instance.master-node-01: Creation complete after 50s [id=fhmb7tpq30ml16j9pkdm]
yandex_compute_instance.slave-node-04: Creation complete after 50s [id=fhmsbi8dad1207ht5q8k]
yandex_compute_instance.slave-node-03: Creation complete after 50s [id=fhmqgf9teprv8s1sfdbq]
yandex_compute_instance.slave-node-01: Still creating... [50s elapsed]
yandex_compute_instance.slave-node-02: Still creating... [50s elapsed]
yandex_compute_instance.slave-node-02: Creation complete after 51s [id=fhmj4rco1jmjjh310mp8]
yandex_compute_instance.slave-node-01: Creation complete after 56s [id=fhmk1mugfjo08qfamveg]

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.
```
Установка и настройка кластера **Kubernetes** с помощью **kubespray**:  
Клонируем репозиторий:  
```commandline
ubuntu@master-node-01:~$ git clone https://github.com/kubernetes-sigs/kubespray
Cloning into 'kubespray'...
remote: Enumerating objects: 62765, done.
remote: Counting objects: 100% (55/55), done.
remote: Compressing objects: 100% (46/46), done.
remote: Total 62765 (delta 12), reused 40 (delta 6), pack-reused 62710
Receiving objects: 100% (62765/62765), 18.24 MiB | 25.38 MiB/s, done.
Resolving deltas: 100% (35321/35321), done.
```
Установка зависимостей:  
<details>
<summary>sudo pip3 install -r requirements.txt</summary>  

```commandline
ubuntu@master-node-01:~/kubespray$ sudo pip3 install -r requirements.txt
Collecting ansible==5.7.1
  Downloading ansible-5.7.1.tar.gz (35.7 MB)
     |████████████████████████████████| 35.7 MB 7.4 kB/s 
Collecting ansible-core==2.12.5
  Downloading ansible-core-2.12.5.tar.gz (7.8 MB)
     |████████████████████████████████| 7.8 MB 43.4 MB/s 
Collecting cryptography==3.4.8
  Downloading cryptography-3.4.8-cp36-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (3.2 MB)
     |████████████████████████████████| 3.2 MB 51.7 MB/s 
Collecting jinja2==2.11.3
  Downloading Jinja2-2.11.3-py2.py3-none-any.whl (125 kB)
     |████████████████████████████████| 125 kB 80.3 MB/s 
Collecting netaddr==0.7.19
  Downloading netaddr-0.7.19-py2.py3-none-any.whl (1.6 MB)
     |████████████████████████████████| 1.6 MB 1.3 kB/s 
Collecting pbr==5.4.4
  Downloading pbr-5.4.4-py2.py3-none-any.whl (110 kB)
     |████████████████████████████████| 110 kB 64.1 MB/s 
Collecting jmespath==0.9.5
  Downloading jmespath-0.9.5-py2.py3-none-any.whl (24 kB)
Collecting ruamel.yaml==0.16.10
  Downloading ruamel.yaml-0.16.10-py2.py3-none-any.whl (111 kB)
     |████████████████████████████████| 111 kB 64.5 MB/s 
Collecting ruamel.yaml.clib==0.2.6
  Downloading ruamel.yaml.clib-0.2.6-cp38-cp38-manylinux1_x86_64.whl (570 kB)
     |████████████████████████████████| 570 kB 58.2 MB/s 
Collecting MarkupSafe==1.1.1
  Downloading MarkupSafe-1.1.1-cp38-cp38-manylinux2010_x86_64.whl (32 kB)
Requirement already satisfied: PyYAML in /usr/lib/python3/dist-packages (from ansible-core==2.12.5->-r requirements.txt (line 2)) (5.3.1)
Collecting packaging
  Downloading packaging-21.3-py3-none-any.whl (40 kB)
     |████████████████████████████████| 40 kB 6.3 MB/s 
Collecting resolvelib<0.6.0,>=0.5.3
  Downloading resolvelib-0.5.4-py2.py3-none-any.whl (12 kB)
Collecting cffi>=1.12
  Downloading cffi-1.15.1-cp38-cp38-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (442 kB)
     |████████████████████████████████| 442 kB 66.9 MB/s 
Collecting pyparsing!=3.0.5,>=2.0.2
  Downloading pyparsing-3.0.9-py3-none-any.whl (98 kB)
     |████████████████████████████████| 98 kB 9.6 MB/s 
Collecting pycparser
  Downloading pycparser-2.21-py2.py3-none-any.whl (118 kB)
     |████████████████████████████████| 118 kB 76.6 MB/s 
Building wheels for collected packages: ansible, ansible-core
  Building wheel for ansible (setup.py) ... done
  Created wheel for ansible: filename=ansible-5.7.1-py3-none-any.whl size=61777681 sha256=50c4c8957303f202228c03a46211495d3e07116900db88d6f1664aa65e38fbbd
  Stored in directory: /root/.cache/pip/wheels/02/07/2a/7b3eb5d79e268b769b0910cded0d524b4647ae5bc19f3ebb70
  Building wheel for ansible-core (setup.py) ... done
  Created wheel for ansible-core: filename=ansible_core-2.12.5-py3-none-any.whl size=2077336 sha256=22f0126a997d117db6b9a454e85b8de4caae78a91d866f9bc1487fb92b271613
  Stored in directory: /root/.cache/pip/wheels/13/09/5b/799a6bc9ca05da9805eaee2afea07e7f63e2ff03b37799d930
Successfully built ansible ansible-core
Installing collected packages: pycparser, cffi, cryptography, MarkupSafe, jinja2, pyparsing, packaging, resolvelib, ansible-core, ansible, netaddr, pbr, jmespath, ruamel.yaml.clib, ruamel.yaml
  Attempting uninstall: cryptography
    Found existing installation: cryptography 2.8
    Not uninstalling cryptography at /usr/lib/python3/dist-packages, outside environment /usr
    Can't uninstall 'cryptography'. No files were found to uninstall.
  Attempting uninstall: MarkupSafe
    Found existing installation: MarkupSafe 1.1.0
    Not uninstalling markupsafe at /usr/lib/python3/dist-packages, outside environment /usr
    Can't uninstall 'MarkupSafe'. No files were found to uninstall.
  Attempting uninstall: jinja2
    Found existing installation: Jinja2 2.10.1
    Not uninstalling jinja2 at /usr/lib/python3/dist-packages, outside environment /usr
    Can't uninstall 'Jinja2'. No files were found to uninstall.
Successfully installed MarkupSafe-1.1.1 ansible-5.7.1 ansible-core-2.12.5 cffi-1.15.1 cryptography-3.4.8 jinja2-2.11.3 jmespath-0.9.5 netaddr-0.7.19 packaging-21.3 pbr-5.4.4 pycparser-2.21 pyparsing-3.0.9 resolvelib-0.5.4 ruamel.yaml-0.16.10 ruamel.yaml.clib-0.2.6
```
</details>  

Подготавливаем файл конфиг:  
`cp -rfp inventory/sample inventory/cluster`  
Далее создаем `host.yml` используя декларативный подход с помощью 
команды `declare`:  
```commandline
ubuntu@master-node-01:~/kubespray$ declare -a IPS=(192.168.101.17 192.168.101.13 192.168.101.3 192.168.101.31 192.168.101.9)
ubuntu@master-node-01:~/kubespray$ CONFIG_FILE=inventory/cluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
DEBUG: Adding group all
DEBUG: Adding group kube_control_plane
DEBUG: Adding group kube_node
DEBUG: Adding group etcd
DEBUG: Adding group k8s_cluster
DEBUG: Adding group calico_rr
DEBUG: adding host node1 to group all
DEBUG: adding host node2 to group all
DEBUG: adding host node3 to group all
DEBUG: adding host node4 to group all
DEBUG: adding host node5 to group all
DEBUG: adding host node1 to group etcd
DEBUG: adding host node2 to group etcd
DEBUG: adding host node3 to group etcd
DEBUG: adding host node1 to group kube_control_plane
DEBUG: adding host node2 to group kube_control_plane
DEBUG: adding host node1 to group kube_node
DEBUG: adding host node2 to group kube_node
DEBUG: adding host node3 to group kube_node
DEBUG: adding host node4 to group kube_node
DEBUG: adding host node5 to group kube_node
```
Редактируем `host.yml`, указываем, что **etcd** находится на мастер ноде:  
```yaml
all:
  hosts:
    node1:
      ansible_host: 192.168.101.17
      ip: 192.168.101.17
      access_ip: 192.168.101.17
    node2:
      ansible_host: 192.168.101.13
      ip: 192.168.101.13
      access_ip: 192.168.101.13
    node3:
      ansible_host: 192.168.101.3
      ip: 192.168.101.3
      access_ip: 192.168.101.3
    node4:
      ansible_host: 192.168.101.31
      ip: 192.168.101.31
      access_ip: 192.168.101.31
    node5:
      ansible_host: 192.168.101.9
      ip: 192.168.101.9
      access_ip: 192.168.101.9
  children:
    kube_control_plane:
      hosts:
        node1:
    kube_node:
      hosts:
        node1:
        node2:
        node3:
        node4:
        node5:
    etcd:
      hosts:
        node1:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}
```
Добавляем внешний доступ через **Loadbalancer**, для этого в файле 
`cluster/group_vars/all/all.yml` редактируем блок **loadbalancer_apiserver**:  
```text
## External LB example config
## apiserver_loadbalancer_domain_name: "elb.some.domain"
 loadbalancer_apiserver:
   address: 51.250.72.104
   port: 6443
```
Редактируем файл `group_vars/k8s_cluster/k8s-cluster.yml`, где указываем,
что в качестве CRI у нас используется **containerd**:
```text
## Container runtime
## docker for docker, crio for cri-o and containerd for containerd.
## Default: containerd
container_manager: containerd
```
Запускаем установку командой 
`ansible-playbook -i inventory/cluster/hosts.yaml --become -u=ubuntu cluster.yml`
и ждем окончания установки:  
```commandline
PLAY RECAP *************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node1                      : ok=752  changed=144  unreachable=0    failed=0    skipped=1243 rescued=0    ignored=9   
node2                      : ok=476  changed=88   unreachable=0    failed=0    skipped=727  rescued=0    ignored=2   
node3                      : ok=476  changed=88   unreachable=0    failed=0    skipped=727  rescued=0    ignored=2   
node4                      : ok=476  changed=88   unreachable=0    failed=0    skipped=727  rescued=0    ignored=2   
node5                      : ok=476  changed=88   unreachable=0    failed=0    skipped=727  rescued=0    ignored=2   

Sunday 10 July 2022  10:56:14 +0000 (0:00:00.116)       0:16:29.867 *********** 
=============================================================================== 
kubernetes/preinstall : Install packages requirements ---------------------------------------------------------------------------------------------------------- 47.87s
download : download_container | Download image if required ----------------------------------------------------------------------------------------------------- 44.86s
download : download_container | Download image if required ----------------------------------------------------------------------------------------------------- 43.25s
download : download_container | Download image if required ----------------------------------------------------------------------------------------------------- 36.21s
kubernetes/kubeadm : Join to cluster --------------------------------------------------------------------------------------------------------------------------- 33.01s
kubernetes/control-plane : Master | Remove scheduler container containerd/crio --------------------------------------------------------------------------------- 29.43s
network_plugin/calico : Calico | Create ipamconfig resources --------------------------------------------------------------------------------------------------- 25.95s
download : download_file | Validate mirrors -------------------------------------------------------------------------------------------------------------------- 24.86s
download : download_container | Download image if required ----------------------------------------------------------------------------------------------------- 21.62s
network_plugin/calico : Wait for calico kubeconfig to be created ----------------------------------------------------------------------------------------------- 20.81s
kubernetes/control-plane : kubeadm | Initialize first master --------------------------------------------------------------------------------------------------- 16.62s
kubernetes-apps/ansible : Kubernetes Apps | Start Resources ---------------------------------------------------------------------------------------------------- 14.80s
download : download_container | Download image if required ----------------------------------------------------------------------------------------------------- 14.56s
kubernetes/preinstall : Update package management cache (APT) -------------------------------------------------------------------------------------------------- 13.99s
download : download_container | Download image if required ----------------------------------------------------------------------------------------------------- 12.26s
download : download_container | Download image if required ------------------------------------------------------------------------------------------------------ 8.98s
kubernetes/node : install | Copy kubelet binary from download dir ----------------------------------------------------------------------------------------------- 8.03s
download : download_container | Download image if required ------------------------------------------------------------------------------------------------------ 7.82s
download : download_container | Download image if required ------------------------------------------------------------------------------------------------------ 7.58s
etcd : reload etcd ---------------------------------------------------------------------------------------------------------------------------------------------- 7.58s

```
Выполняем локальную проверку работоспособности кластера:  
```commandline
root@node1:/home/ubuntu/kubespray# kubectl version --short
Flag --short has been deprecated, and will be removed in the future. The --short output will become the default.
Client Version: v1.24.2
Kustomize Version: v4.5.4
Server Version: v1.24.2
root@node1:/home/ubuntu/kubespray# kubectl get nodes
NAME    STATUS   ROLES           AGE   VERSION
node1   Ready    control-plane   16m   v1.24.2
node2   Ready    <none>          14m   v1.24.2
node3   Ready    <none>          14m   v1.24.2
node4   Ready    <none>          14m   v1.24.2
node5   Ready    <none>          14m   v1.24.2
root@node1:/home/ubuntu/kubespray# kubectl create deploy nginx --image=nginx:latest --replicas=2
deployment.apps/nginx created
root@node1:/home/ubuntu/kubespray# kubectl get po -o wide
NAME                     READY   STATUS    RESTARTS   AGE   IP            NODE    NOMINATED NODE   READINESS GATES
nginx-7597c656c9-9tgfw   1/1     Running   0          22s   10.233.92.1   node3   <none>           <none>
nginx-7597c656c9-n9tf4   1/1     Running   0          22s   10.233.70.1   node5   <none>           <none>
```
Выполняем удаленную проверку работоспособности кластера с локальной 
машины:  
```commandline
[jekis_@nb-5583 ~]$ kubectl version --short
Flag --short has been deprecated, and will be removed in the future. The --short output will become the default.
Client Version: v1.24.2
Kustomize Version: v4.5.4
Server Version: v1.24.2
[jekis_@nb-5583 ~]$ kubectl get nodes
NAME    STATUS   ROLES           AGE   VERSION
node1   Ready    control-plane   50m   v1.24.2
node2   Ready    <none>          49m   v1.24.2
node3   Ready    <none>          49m   v1.24.2
node4   Ready    <none>          49m   v1.24.2
node5   Ready    <none>          49m   v1.24.2
[jekis_@nb-5583 ~]$ kubectl get pods -o wide
NAME                     READY   STATUS    RESTARTS   AGE   IP            NODE    NOMINATED NODE   READINESS GATES
nginx-7597c656c9-9tgfw   1/1     Running   0          35m   10.233.92.1   node3   <none>           <none>
nginx-7597c656c9-n9tf4   1/1     Running   0          35m   10.233.70.1   node5   <none>           <none>
```
