### Задание 1: подключить для тестового конфига общую папку.  

---
В stage окружении часто возникает необходимость отдавать статику 
бекенда сразу фронтом. Проще всего сделать это через общую папку.   
Требования:  
* в поде подключена общая папка между контейнерами (например, /static);  
* после записи чего-либо в контейнере с беком файлы можно получить из 
контейнера с фронтом.  


Из прошлого задания обновим манифест файл и добавим в 
него описание общего каталога `/static` с именем 
`test-volume`, применим его и выполним проверку, что каталог в системе
является общим между подами:  
[stage_front-back.yaml](stage_front-back.yaml)  
```commandline
root@node1:/home/ubuntu/kubespray# kubectl config set-context --current --namespace=stage
Context "kubernetes-admin@cluster.local" modified.
root@node1:/home/ubuntu# kubectl apply -f stage_front-back.yaml 
deployment.apps/frontend-backend created
service/frontend-backend created
root@node1:/home/ubuntu# kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
frontend-backend-84ddc68f8f-kbggj   2/2     Running   0          69s
root@node1:/home/ubuntu# kubectl exec frontend-backend-84ddc68f8f-kbggj -c backend -- ls -la /static
total 8
drwxrwxrwx 2 root root 4096 Aug 15 18:00 .
drwxr-xr-x 1 root root 4096 Aug 15 18:01 ..
root@node1:/home/ubuntu# kubectl exec frontend-backend-84ddc68f8f-kbggj -c backend -- sh -c "echo 'netology_test_volume' > /static/netology.txt"
root@node1:/home/ubuntu# kubectl exec frontend-backend-84ddc68f8f-kbggj -c backend -- cat /static/netology.txt
netology_test_volume
root@node1:/home/ubuntu# kubectl exec frontend-backend-84ddc68f8f-kbggj -c frontend -- ls -la /static
total 12
drwxrwxrwx 2 root root 4096 Aug 15 18:04 .
drwxr-xr-x 1 root root 4096 Aug 15 18:00 ..
-rw-r--r-- 1 root root   21 Aug 15 18:04 netology.txt
root@node1:/home/ubuntu# kubectl exec frontend-backend-84ddc68f8f-kbggj -c frontend -- cat /static/netology.txt
netology_test_volume
```
Done!!!  

---
### Задание 2: подключить общую папку для прода  

---
Поработав на stage, доработки нужно отправить на прод. В продуктиве 
у нас контейнеры крутятся в разных подах, поэтому потребуется PV и 
связь через PVC. Сам PV должен быть связан с NFS сервером. 
Требования:  
* все бекенды подключаются к одному PV в режиме ReadWriteMany;  
* фронтенды тоже подключаются к этому же PV с таким же режимом;  
* файлы, созданные бекендом, должны быть доступны фронту.  

Так же редактируем манифесты из предыдущего задания, добавляем туда 
информацию о директории, создаем дополнительный манифест 
[pvc.yaml](pvc.yaml) где описываем наш сторедж, применяем и выполняем 
проверки:  
[prod_front.yaml](prod_front.yaml)  
[prod_back.yaml](prod_back.yaml)
```commandline
root@node1:/home/ubuntu# kubectl config set-context --current --namespace=prod
Context "kubernetes-admin@cluster.local" modified.
root@node1:/home/ubuntu# kubectl apply -f prod/
statefulset.apps/postgres created
service/postgres created
deployment.apps/backend created
service/backend created
deployment.apps/frontend created
service/frontend created
persistentvolumeclaim/test-dynamic-volume-claim created
root@node1:/home/ubuntu# kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
backend-78b944c89b-bhcxh    1/1     Running   0          41s
frontend-78849f496b-dzs9k   1/1     Running   0          41s
postgres-0                  1/1     Running   0          41s
root@node1:/home/ubuntu# kubectl get pods -n default
NAME                                  READY   STATUS    RESTARTS   AGE
nfs-server-nfs-server-provisioner-0   1/1     Running   0          66m
root@node1:/home/ubuntu# kubectl get pvc
NAME                        STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
test-dynamic-volume-claim   Bound    pvc-6babe100-c612-493f-a88e-0c911b74d757   1Gi        RWX            nfs            52s
root@node1:/home/ubuntu# kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                            STORAGECLASS   REASON   AGE
pvc-6babe100-c612-493f-a88e-0c911b74d757   1Gi        RWX            Delete           Bound    prod/test-dynamic-volume-claim   nfs                     77s
root@node1:/home/ubuntu# kubectl exec backend-78b944c89b-bhcxh -- ls -la /static
total 8
drwxrwsrwx 2 root root 4096 Aug 15 18:37 .
drwxr-xr-x 1 root root 4096 Aug 15 18:37 ..
root@node1:/home/ubuntu# kubectl exec backend-78b944c89b-bhcxh -- sh -c "echo 'netology_test_pvc_nfs' > /static/netology.txt"
root@node1:/home/ubuntu# kubectl exec backend-78b944c89b-bhcxh -- cat /static/netology.txt
netology_test_pvc_nfs
root@node1:/home/ubuntu# kubectl exec frontend-78849f496b-dzs9k -- ls -la /static
total 12
drwxrwsrwx 2 root root 4096 Aug 15 18:40 .
drwxr-xr-x 1 root root 4096 Aug 15 18:37 ..
-rw-r--r-- 1 root root   22 Aug 15 18:40 netology.txt
root@node1:/home/ubuntu# kubectl exec frontend-78849f496b-dzs9k -- cat /static/netology.txt
netology_test_pvc_nfs
```
Done!!!
