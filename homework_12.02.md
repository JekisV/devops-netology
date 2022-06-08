### Запуск пода из образа в деплойменте  
* пример из `hello world` запущен в качестве `deployment`  
* количество реплик в `deployment` установлено в 2  
* наличие `deployment` можно проверить командой `kubectl get deployment`  
* наличие подов можно проверить командой `kubectl get pods`  
```commandline
root@node-01:/home/ubuntu# kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4 --replicas=2 
deployment.apps/hello-node created
root@node-01:/home/ubuntu# kubectl get deployments
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   2/2     2            2           42s
root@node-01:/home/ubuntu# kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
hello-node-6b89d599b9-6xrm6   1/1     Running   0          50s
hello-node-6b89d599b9-v7dxp   1/1     Running   0          50s
```
---
### Просмотр логов для разработки
* создан новый токен доступа для пользователя
```commandline
root@node-01:/home/ubuntu# kubectl -n test-space create serviceaccount user1
serviceaccount/user1 created
root@node-01:/home/ubuntu# export TOKENNAME=$(kubectl -n test-space get serviceaccount/user1 -o jsonpath='{.secrets[0].name}')
root@node-01:/home/ubuntu# export TOKEN=$(kubectl -n test-space get secret $TOKENNAME -o jsonpath='{.data.token}' | base64 --decode)
root@node-01:/home/ubuntu# echo $TOKEN
eyJhbGciOiJSUzI1NiIsImtpZCI6InpkV3BiOFNSQkc3aERDYjJzQ1pENmkwRFZkQ1Y4ejREcG0wSlpicl9qbjAifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJ0ZXN0LXNwYWNlIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6InVzZXIxLXRva2VuLWp3a3pkIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6InVzZXIxIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiM2Y4NTJlMTItMTVmNy00NmYyLThmMTEtNDFjZWJlMDJkOWQwIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OnRlc3Qtc3BhY2U6dXNlcjEifQ.RBIlkyj35m2dD1JtP5plyv-AbrINUQtpHw7sjHVOzg8z_sd-B5MJwRDVgwgXgUNMPGxtrD1cAJBV14zE4yk7t-HqOXUYjrhih_pLzxuCMVwCz8wHASpYAxg6deI7fv_ZE_ET0Fj9UPuiDYYUPqPKbvlIoOARvOjVCSpNpNou0LVJqe96T8zJBHYUrGTp76-8nvtfSG2Rm3QL0PhUVdzQTG5x5ergSjaEJNuVBr88QPhMXqif1fmmWWSTUvB_7QGTaIy5z9GdWX518UxGAdZuJoudTfaU5p19tbRtyI8qvqHcTn84Yja2Xt4Uv9PRfLPAK7cH9oQgCu1LV3fJy6uaKQ
```
* пользователь прописан в локальный конфиг (~/.kube/config, блок users)
```commandline
apiVersion: v1
clusters:
- cluster:
    certificate-authority: /root/.minikube/ca.crt
    extensions:
    - extension:
        last-update: Wed, 08 Jun 2022 18:09:06 UTC
        provider: minikube.sigs.k8s.io
        version: v1.25.2
      name: cluster_info
    server: https://192.168.101.15:8443
  name: minikube
contexts:
- context:
    cluster: minikube
    extensions:
    - extension:
        last-update: Wed, 08 Jun 2022 18:09:06 UTC
        provider: minikube.sigs.k8s.io
        version: v1.25.2
      name: context_info
    namespace: default
    user: minikube
  name: minikube
- context:
    cluster: minikube
    namespace: test-space
    user: user1
  name: test1
current-context: minikube
kind: Config
preferences: {}
users:
- name: user1
  user:
    token: eyJhbGciOiJSUzI1NiIsImtpZCI6InpkV3BiOFNSQkc3aERDYjJzQ1pENmkwRFZkQ1Y4ejREcG0wSlpicl9qbjAifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJ0ZXN0LXNwYWNlIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6InVzZXIxLXRva2VuLWp3a3pkIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6InVzZXIxIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiM2Y4NTJlMTItMTVmNy00NmYyLThmMTEtNDFjZWJlMDJkOWQwIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OnRlc3Qtc3BhY2U6dXNlcjEifQ.RBIlkyj35m2dD1JtP5plyv-AbrINUQtpHw7sjHVOzg8z_sd-B5MJwRDVgwgXgUNMPGxtrD1cAJBV14zE4yk7t-HqOXUYjrhih_pLzxuCMVwCz8wHASpYAxg6deI7fv_ZE_ET0Fj9UPuiDYYUPqPKbvlIoOARvOjVCSpNpNou0LVJqe96T8zJBHYUrGTp76-8nvtfSG2Rm3QL0PhUVdzQTG5x5ergSjaEJNuVBr88QPhMXqif1fmmWWSTUvB_7QGTaIy5z9GdWX518UxGAdZuJoudTfaU5p19tbRtyI8qvqHcTn84Yja2Xt4Uv9PRfLPAK7cH9oQgCu1LV3fJy6uaKQ
```
* пользователь может просматривать логи подов и их конфигурацию 
(kubectl logs pod <pod_id>, kubectl describe pod <pod_id>)
```commandline
[user1@node-01 ~]# kubectl describe pods hello-node-6b89d599b9-c97jm
Name:         hello-node-6b89d599b9-c97jm
Namespace:    default
Priority:     0
Node:         node-01/192.168.101.15
Start Time:   Wed, 08 Jun 2022 18:58:08 +0000
Labels:       app=hello-node
              pod-template-hash=6b89d599b9
Annotations:  <none>
Status:       Running
IP:           172.17.0.3
IPs:
  IP:           172.17.0.3
Controlled By:  ReplicaSet/hello-node-6b89d599b9
Containers:
  echoserver:
    Container ID:   docker://38e80d526df33bece418a17c2d0e68e05a4eadadba097403e8edb1b3a0075dc5
    Image:          k8s.gcr.io/echoserver:1.4
    Image ID:       docker-pullable://k8s.gcr.io/echoserver@sha256:5d99aa1120524c801bc8c1a7077e8f5ec122ba16b6dda1a5d3826057f67b9bcb
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Wed, 08 Jun 2022 18:58:10 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-nl7fd (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  kube-api-access-nl7fd:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  19m   default-scheduler  Successfully assigned default/hello-node-6b89d599b9-c97jm to node-01
  Normal  Pulled     19m   kubelet            Container image "k8s.gcr.io/echoserver:1.4" already present on machine
  Normal  Created    19m   kubelet            Created container echoserver
  Normal  Started    19m   kubelet            Started container echoserver
[user1@node-01 ~]# kubectl logs hello-node-6b89d599b9-c97jm
```
---
### Изменение количества реплик
* в deployment из задания 1 изменено количество реплик на 5
```commandline
root@node-01:/home/ubuntu# kubectl scale --replicas=5 deployment hello-node
deployment.apps/hello-node scaled
```
* проверить что все поды перешли в статус running (kubectl get pods)
```commandline
root@node-01:/home/ubuntu# kubectl get deployments
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   5/5     5            5           28m
root@node-01:/home/ubuntu# kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
hello-node-6b89d599b9-4lm44   1/1     Running   0          2m21s
hello-node-6b89d599b9-c97jm   1/1     Running   0          29m
hello-node-6b89d599b9-k2fqb   1/1     Running   0          29m
hello-node-6b89d599b9-rgrv4   1/1     Running   0          2m21s
hello-node-6b89d599b9-w9rqk   1/1     Running   0          2m21s
```