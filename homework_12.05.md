### Установить в кластер CNI плагин Calico  
**Calico** установлен по умолчанию в кластере после 
установке через **kuberspray**:  
```commandline
root@node1:/home/ubuntu/kubespray# kubectl get pods -A
NAMESPACE     NAME                              READY   STATUS    RESTARTS        AGE
kube-system   calico-node-9nm8n                 1/1     Running   1 (4m18s ago)   4m52s
kube-system   calico-node-mk2fp                 1/1     Running   0               4m52s
kube-system   coredns-666959ff67-7nlws          1/1     Running   0               3m13s
kube-system   coredns-666959ff67-lbksb          1/1     Running   0               3m27s
kube-system   dns-autoscaler-59b8867c86-69tzk   1/1     Running   0               3m19s
kube-system   kube-apiserver-node1              1/1     Running   1               6m54s
kube-system   kube-controller-manager-node1     1/1     Running   3 (4m29s ago)   6m51s
kube-system   kube-proxy-j7pv9                  1/1     Running   0               5m17s
kube-system   kube-proxy-xnjwz                  1/1     Running   0               6m37s
kube-system   kube-scheduler-node1              1/1     Running   2 (4m29s ago)   6m51s
kube-system   nodelocaldns-6xd7j                1/1     Running   0               3m13s
kube-system   nodelocaldns-jcm9s                1/1     Running   0               3m13s
```
#### Настройка политик  
Создадим два приложения в двух разных неймспейсах:  
1. неймспейс `app` и приложение `hello-node`:
```commandline
root@node1:/home/ubuntu/kubespray# kubectl create namespace app
namespace/app created
root@node1:/home/ubuntu/kubespray# kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4 --namespace=app
deployment.apps/hello-node created
```
2. неймспейс `tools` и приложение `multitool`:  
```commandline
root@node1:/home/ubuntu/kubespray# kubectl create namespace tools
namespace/tools created
root@node1:/home/ubuntu/kubespray# kubectl create deployment multitool --image=praqma/network-multitool:alpine-extra --namespace=tools
deployment.apps/multitool created
```
В созданных подах политики отсутствуют, проверяем доступность 
пода `hello-node` из пода `multitool`:  
```commandline
root@node1:/home/ubuntu/kubespray# kubectl -n tools exec multitool-5958664c8b-hcfzl -- curl 10.233.96.2:8080
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   292    0   292    0     0   127k      0 --:--:-- --:--:-CLIENT VALUES: 0
- --:--:--  285k
client_address=10.233.96.3
command=GET
real path=/
query=nil
request_version=1.1
request_uri=http://10.233.96.2:8080/

SERVER VALUES:
server_version=nginx: 1.10.0 - lua: 10001

HEADERS RECEIVED:
accept=*/*
host=10.233.96.2:8080
user-agent=curl/7.79.1
BODY:
-no body in request-
```
Доступ есть, но нет политик запрета. Для этого создадим default политику
запрет на всё входящее в namespace `app` в формате:  
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: app
spec:
podSelector: {}
policyTypes:
    - Ingress
```
И применим ее:  
```commandline
root@node1:/home/ubuntu/kubespray# kubectl apply -f ./templates/network-policy/00-default.yaml
networkpolicy.networking.k8s.io/default-deny-ingress created
```
Проверяем доступность пода `hello-node` из пода `multitool`:  
```commandline
root@node1:/home/ubuntu/kubespray# kubectl -n tools exec multitool-5958664c8b-hcfzl -- curl 10.233.96.2:8080
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:07 --:--:--     0^C
```
Под не отвечает. Политика доступа к подам в namespace `app` применена.  

Создадим политику входящего трафика для namespace `app` из namespace 
`multitool`:  
```yaml
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: allow-to-app-hello-node
  namespace: app
spec:
podSelector:
    matchLabels:
    app: hello-node
policyTypes:
  - Ingress     
ingress:
  - from:
    - podSelector:
        matchLabels:
          app: multitool
    namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: multitool
    ports:
      - protocol: TCP
    port: 8080
```
и применим ее:  
```commandline
root@node1:/home/ubuntu/kubespray# kubectl apply -f templates/network-policy/10-default_2.yaml --validate=false
networkpolicy.networking.k8s.io/allow-to-app-hello-node created
root@node1:/home/ubuntu/kubespray# kubectl -n app get networkpolicies
NAME                      POD-SELECTOR   AGE
allow-to-app-hello-node   <none>         3m1s
default-deny-ingress      <none>         13m
```
Выполним проверку доступности пода `hello-node` в namespace `app` 
из пода `multitool` в namespace `tools`:  
```commandline
root@node1:/home/ubuntu/kubespray# kubectl -n tools exec multitool-5958664c8b-hcfzl -- curl 10.233.96.2:8080
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   292    0   292    0     0  CLIENT VALUES:-:--:-- --:--:-- --:--:--     0
 111k      0 --:--:-- --:--:-- --:--:--  142k
client_address=10.233.96.3
command=GET
real path=/
query=nil
request_version=1.1
request_uri=http://10.233.96.2:8080/

SERVER VALUES:
server_version=nginx: 1.10.0 - lua: 10001

HEADERS RECEIVED:
accept=*/*
host=10.233.96.2:8080
user-agent=curl/7.79.1
BODY:
-no body in request-
```
Выполним проверку **ping**:  
```commandline
root@node1:/home/ubuntu/kubespray# kubectl -n tools exec multitool-5958664c8b-hcfzl -- ping 10.233.96.2
PING 10.233.96.2 (10.233.96.2) 56(84) bytes of data.
^
```

Доступа нет, соответственно, политика работает.  

---
### Изучить, что запущено по умолчанию  
```commandline
root@node1:/home/ubuntu/kubespray# calicoctl get node
NAME    
node1   
node2   

root@node1:/home/ubuntu/kubespray# calicoctl get ipPool
NAME           CIDR             SELECTOR   
default-pool   10.233.64.0/18   all()      

root@node1:/home/ubuntu/kubespray# calicoctl get profile
NAME                                                 
projectcalico-default-allow                          
kns.app                                              
kns.default                                          
kns.kube-node-lease                                  
kns.kube-public                                      
kns.kube-system                                      
kns.tools                                            
ksa.app.default                                      
ksa.default.default                                  
ksa.kube-node-lease.default                          
ksa.kube-public.default                              
ksa.kube-system.attachdetach-controller              
ksa.kube-system.bootstrap-signer                     
ksa.kube-system.calico-node                          
ksa.kube-system.certificate-controller               
ksa.kube-system.clusterrole-aggregation-controller   
ksa.kube-system.coredns                              
ksa.kube-system.cronjob-controller                   
ksa.kube-system.daemon-set-controller                
ksa.kube-system.default                              
ksa.kube-system.deployment-controller                
ksa.kube-system.disruption-controller                
ksa.kube-system.dns-autoscaler                       
ksa.kube-system.endpoint-controller                  
ksa.kube-system.endpointslice-controller             
ksa.kube-system.endpointslicemirroring-controller    
ksa.kube-system.ephemeral-volume-controller          
ksa.kube-system.expand-controller                    
ksa.kube-system.generic-garbage-collector            
ksa.kube-system.horizontal-pod-autoscaler            
ksa.kube-system.job-controller                       
ksa.kube-system.kube-proxy                           
ksa.kube-system.namespace-controller                 
ksa.kube-system.node-controller                      
ksa.kube-system.nodelocaldns                         
ksa.kube-system.persistent-volume-binder             
ksa.kube-system.pod-garbage-collector                
ksa.kube-system.pv-protection-controller             
ksa.kube-system.pvc-protection-controller            
ksa.kube-system.replicaset-controller                
ksa.kube-system.replication-controller               
ksa.kube-system.resourcequota-controller             
ksa.kube-system.root-ca-cert-publisher               
ksa.kube-system.service-account-controller           
ksa.kube-system.service-controller                   
ksa.kube-system.statefulset-controller               
ksa.kube-system.token-cleaner                        
ksa.kube-system.ttl-after-finished-controller        
ksa.kube-system.ttl-controller                       
ksa.tools.default
```
