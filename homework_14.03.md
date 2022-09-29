Как создать карту конфигураций?
```commandline
root@node1:/home/ubuntu/clokub-homeworks/14.3# kubectl create configmap nginx-config --from-file=nginx.conf
configmap/nginx-config created
root@node1:/home/ubuntu/clokub-homeworks/14.3# kubectl create configmap domain --from-literal=name=netology.ru
configmap/domain created
```
Как просмотреть список карт конфигураций?  
```commandline
root@node1:/home/ubuntu/clokub-homeworks/14.3# kubectl get configmaps
NAME               DATA   AGE
domain             1      23s
kube-root-ca.crt   1      22h
nginx-config       1      41s
root@node1:/home/ubuntu/clokub-homeworks/14.3# kubectl get configmap
NAME               DATA   AGE
domain             1      33s
kube-root-ca.crt   1      22h
nginx-config       1      51s
```
Как просмотреть карту конфигурации?  
```commandline
root@node1:/home/ubuntu/clokub-homeworks/14.3# kubectl get configmap nginx-config
NAME           DATA   AGE
nginx-config   1      79s
root@node1:/home/ubuntu/clokub-homeworks/14.3# kubectl describe configmap domain
Name:         domain
Namespace:    test-pod
Labels:       <none>
Annotations:  <none>

Data
====
name:
----
netology.ru

BinaryData
====

Events:  <none>
```
Как получить информацию в формате YAML и/или JSON?  
```commandline
root@node1:/home/ubuntu/clokub-homeworks/14.3# kubectl get configmap nginx-config -o yaml
apiVersion: v1
data:
  nginx.conf: |
    server {
        listen 80;
        server_name  netology.ru www.netology.ru;
        access_log  /var/log/nginx/domains/netology.ru-access.log  main;
        error_log   /var/log/nginx/domains/netology.ru-error.log info;
        location / {
            include proxy_params;
            proxy_pass http://10.10.10.10:8080/;
        }
    }
kind: ConfigMap
metadata:
  creationTimestamp: "2022-09-29T18:06:47Z"
  name: nginx-config
  namespace: test-pod
  resourceVersion: "130059"
  uid: df3dc0a0-3b45-422c-9d89-adf5900e4e32
root@node1:/home/ubuntu/clokub-homeworks/14.3# kubectl get configmap domain -o json
{
    "apiVersion": "v1",
    "data": {
        "name": "netology.ru"
    },
    "kind": "ConfigMap",
    "metadata": {
        "creationTimestamp": "2022-09-29T18:07:05Z",
        "name": "domain",
        "namespace": "test-pod",
        "resourceVersion": "130087",
        "uid": "5bad16d2-0c68-4bee-9240-49b8f140cfae"
    }
}
```
Как выгрузить карту конфигурации и сохранить его в файл?  
```commandline
root@node1:/home/ubuntu/clokub-homeworks/14.3# kubectl get configmaps -o json > configmaps.json
root@node1:/home/ubuntu/clokub-homeworks/14.3# kubectl get configmap nginx-config -o yaml > nginx-config.yml
root@node1:/home/ubuntu/clokub-homeworks/14.3# ll
total 32
drwxr-xr-x 3 root root 4096 Sep 29 18:10 ./
drwxr-xr-x 7 root root 4096 Sep 29 18:06 ../
-rw-r--r-- 1 root root 3222 Sep 29 18:10 configmaps.json
-rw-r--r-- 1 root root  370 Sep 29 18:06 generator.py
-rw-r--r-- 1 root root  576 Sep 29 18:06 myapp-pod.yml
-rw-r--r-- 1 root root  306 Sep 29 18:06 nginx.conf
-rw-r--r-- 1 root root  568 Sep 29 18:10 nginx-config.yml
drwxr-xr-x 2 root root 4096 Sep 29 18:06 templates/
```
Как удалить карту конфигурации?  
```commandline
root@node1:/home/ubuntu/clokub-homeworks/14.3# kubectl delete configmap nginx-config
configmap "nginx-config" deleted
```
Как загрузить карту конфигурации из файла?  
```commandline
root@node1:/home/ubuntu/clokub-homeworks/14.3# kubectl apply -f nginx-config.yml
configmap/nginx-config created
root@node1:/home/ubuntu/clokub-homeworks/14.3# kubectl get configmap
NAME               DATA   AGE
domain             1      5m8s
kube-root-ca.crt   1      22h
nginx-config       1      39s
```