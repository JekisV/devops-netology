### Задание 1: подготовить тестовый конфиг для запуска приложения  

---
Для начала следует подготовить запуск приложения в stage окружении с 
простыми настройками. Требования:  
* под содержит в себе 2 контейнера — фронтенд, бекенд;  
* регулируется с помощью deployment фронтенд и бекенд;  
* база данных — через statefulset.  

[stage_front-back.yml](stage_front-back.yml)  
[stage_db.yml](stage_db.yml)  
```commandline
root@node1:/home/ubuntu# kubectl config set-context --current --namespace=stage
Context "kubernetes-admin@cluster.local" modified.
root@node1:/home/ubuntu# kubectl create -f stage_db.yml 
statefulset.apps/postgres created
service/postgres created
root@node1:/home/ubuntu# kubectl create -f stage_front-back.yml 
deployment.apps/frontend-backend created
service/frontend-backend created
root@node1:/home/ubuntu# kubectl get pods -o wide
NAME                               READY   STATUS    RESTARTS   AGE     IP               NODE    NOMINATED NODE   READINESS GATES
frontend-backend-b6c84c57c-mb4xg   2/2     Running   0          2m14s   10.233.102.134   node1   <none>           <none>
postgres-0                         1/1     Running   0          2m29s   10.233.102.133   node1   <none>           <none>
postgres-0                         1/1     Running   0          2m29s   10.233.102.133   node1   <none>           <none>
root@node1:/home/ubuntu# kubectl get svc
NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)           AGE
frontend-backend   ClusterIP   10.233.58.131   <none>        80/TCP,9000/TCP   2m52s
postgres           ClusterIP   10.233.35.12    <none>        5432/TCP          3m7s
root@node1:/home/ubuntu# kubectl get statefulsets.apps -o wide
NAME       READY   AGE     CONTAINERS   IMAGES
postgres   1/1     6m21s   postgres     postgres:13-alpine
```
---
### Задание 2: подготовить конфиг для production окружения  

---
Следующим шагом будет запуск приложения в production окружении. 
Требования сложнее:
* каждый компонент (база, бекенд, фронтенд) запускаются в своем поде, 
регулируются отдельными deployment’ами;  
* для связи используются service (у каждого компонента свой);  
* в окружении фронта прописан адрес сервиса бекенда;  
* в окружении бекенда прописан адрес сервиса базы данных.  

[prod_front.yml](prod_front.yml)  
[prod_back.yml](prod_back.yml)
```commandline
root@node1:/home/ubuntu# kubectl config set-context --current --namespace=prod
Context "kubernetes-admin@cluster.local" modified.
root@node1:/home/ubuntu# kubectl create -f stage_db.yml 
statefulset.apps/postgres created
service/postgres created
root@node1:/home/ubuntu# kubectl create -f prod_back.yml 
deployment.apps/backend created
service/backend created
root@node1:/home/ubuntu# kubectl create -f prod_front.yml 
deployment.apps/frontend created
service/frontend created
root@node1:/home/ubuntu# kubectl get svc
NAME       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
backend    ClusterIP   10.233.24.144   <none>        9000/TCP   48s
frontend   ClusterIP   10.233.30.45    <none>        80/TCP     44s
postgres   ClusterIP   10.233.1.125    <none>        5432/TCP   60s
root@node1:/home/ubuntu# kubectl get pods -o wide
NAME                        READY   STATUS    RESTARTS   AGE   IP               NODE    NOMINATED NODE   READINESS GATES
backend-c77d7f6d4-5lv6z     1/1     Running   0          75s   10.233.102.135   node1   <none>           <none>
frontend-67f789bf46-d2lbl   1/1     Running   0          71s   10.233.102.136   node1   <none>           <none>
postgres-0                  1/1     Running   0          86s   10.233.75.4      node2   <none>           <none>
root@node1:/home/ubuntu# kubectl get deployments.apps
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
backend    1/1     1            1           99s
frontend   1/1     1            1           95s
root@node1:/home/ubuntu# kubectl get statefulsets
NAME       READY   AGE
postgres   1/1     2m13s
root@node1:/home/ubuntu# kubectl port-forward frontend-67f789bf46-d2lbl 8080:80
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080
Handling connection for 8080
```