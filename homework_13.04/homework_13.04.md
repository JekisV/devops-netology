### Задание 1: подготовить helm чарт для приложения  

---
Необходимо упаковать приложение в чарт для деплоя в разные окружения. 
Требования:  
* каждый компонент приложения деплоится отдельным deployment’ом/
statefulset’ом;  
* в переменных чарта измените образ приложения для изменения версии.

---
Создаем чарт `chart1`:  
```commandline
root@node1:/home/ubuntu/kubespray# helm create chart1
Creating chart1
```
Редактируем deployment.yaml, namespace.yaml, service.yaml, 
statefulset.yaml и value.yaml:  
[deployment.yaml](chart1/templates/deployment.yaml)  
[namespace.yaml](chart1/templates/namespace.yaml)  
[service.yaml](chart1/templates/service.yaml)  
[statefulset.yaml](chart1/templates/statefulset.yaml)  
[value.yaml](chart1/values.yaml)  

Выполняем проверку:  
```commandline
root@node1:/home/ubuntu/kubespray# helm lint chart1/
==> Linting chart1/
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, 0 chart(s) failed
```
Проверяем вывод готового шаблона:  
```commandline
root@node1:/home/ubuntu/kubespray# helm template chart1
---
# Source: chart1/templates/namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: helm
---
# Source: chart1/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: postgres
  namespace: helm
spec:
  selector:
    app: postgres
  ports:
    - name: postgres
      port: 5432
---
# Source: chart1/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  namespace: helm
  name: frontend-backend
spec:
  selector:
    app: frontend-backend
  ports:
    - name: front
      protocol: TCP
      port: 80
    - name: back
      protocol: TCP
      port: 9000
---
# Source: chart1/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-backend
  namespace: helm
  labels:
    app: frontend-backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend-backend
  template:
    metadata:
      labels:
        app: frontend-backend
    spec:
      containers:
      - image: "jekisv/frontend:latest"
        imagePullPolicy: IfNotPresent
        name: frontend
        ports:
        - containerPort: 80
        volumeMounts:
        - mountPath: /static
          name: test-volume
        env:
          - name: BASE_URL
            value: http://localhost:9000
      - image: "jekisv/backend:latest"
        imagePullPolicy: IfNotPresent
        name: backend
        ports:
        - containerPort: 9000
        volumeMounts:
        - mountPath: /static
          name: test-volume
        env:
          - name: DATABASE_URL
            value: postgres://postgres:postgres@postgres:5432/news
      volumes:
        - name: test-volume
          emptyDir: {}
---
# Source: chart1/templates/statefulset.yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
  namespace: helm
  labels:
    app: postgres
spec:
  serviceName: "postgres"
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: "postgres:13-alpine"
        imagePullPolicy: IfNotPresent
        ports:
          - containerPort: 5432
        volumeMounts:
          - name: db-volume
            mountPath: /data
        env:
          - name: POSTGRES_PASSWORD
            value: postgres
          - name: POSTGRES_USER
            value: postgres
          - name: POSTGRES_DB
            value: news
      volumes:
        - name: db-volume
```
В итоге наблюдаем ожидаемый результат.  

---

### Задание 2: запустить 2 версии в разных неймспейсах  
Подготовив чарт, необходимо его проверить. Попробуйте запустить 
несколько копий приложения:
* одну версию в namespace=app1;  
* вторую версию в том же неймспейсе;  
* третью версию в namespace=app2.  

---

Деплоим текущую версию приложения в namespace app1 и выполняем проверку:  
```commandline
root@node1:/home/ubuntu/kubespray# helm install --set namespace=app1 v.1 chart1
NAME: v.1
LAST DEPLOYED: Sat Sep 10 13:07:58 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
root@node1:/home/ubuntu/kubespray# kubectl -n app1 get pod,deployments.apps,service,statefulsets.apps
NAME                                    READY   STATUS    RESTARTS   AGE
pod/frontend-backend-6677bb5789-d6cwr   2/2     Running   0          2m36s
pod/postgres-0                          1/1     Running   0          2m36s

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/frontend-backend   1/1     1            1           2m36s

NAME                       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)           AGE
service/frontend-backend   ClusterIP   10.233.19.182   <none>        80/TCP,9000/TCP   2m36s
service/postgres           ClusterIP   10.233.43.144   <none>        5432/TCP          2m36s

NAME                        READY   AGE
statefulset.apps/postgres   1/1     2m36s
```
Приложение успешно развернулось.  
Меняем версию в файле `Chart.yaml` c `appVersion: "1.16.0"` на 
`appVersion: "1.20.0"` и пробуем запустить вторую версию в том же
неймспейсе:  
```commandline
root@node1:/home/ubuntu/kubespray# helm upgrade --install --set namespace=app1 v.1 chart1
Release "v.1" has been upgraded. Happy Helming!
NAME: v.1
LAST DEPLOYED: Sat Sep 10 13:22:38 2022
NAMESPACE: default
STATUS: deployed
REVISION: 2
TEST SUITE: None
```
Проверяем деплой Helm:  
```commandline
root@node1:/home/ubuntu/kubespray# helm list
NAME	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART       	APP VERSION
v.1 	default  	2       	2022-09-10 13:22:38.634219037 +0000 UTC	deployed	chart1-0.1.0	1.20.0
```
Версия обновилась до указанной 1.20.0, REVISION стала 2.  
В итоге запустить одно и тоже приложение в том же неймспейсе не удалось.  
Запускаем третью версию в namespace app2 и выполняем проверку:  
```commandline
root@node1:/home/ubuntu/kubespray# helm upgrade --install --set namespace=app2 v.3 chart1
Release "v.3" does not exist. Installing it now.
NAME: v.3
LAST DEPLOYED: Sat Sep 10 13:28:51 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
root@node1:/home/ubuntu/kubespray# helm list
NAME	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART       	APP VERSION
v.1 	default  	2       	2022-09-10 13:22:38.634219037 +0000 UTC	deployed	chart1-0.1.0	1.20.0     
v.3 	default  	1       	2022-09-10 13:28:51.322651599 +0000 UTC	deployed	chart1-0.1.0	1.20.0
root@node1:/home/ubuntu/kubespray# kubectl get namespace
NAME              STATUS   AGE
app1              Active   22m
app2              Active   106s
default           Active   87m
kube-node-lease   Active   87m
kube-public       Active   87m
kube-system       Active   87m
root@node1:/home/ubuntu/kubespray# kubectl -n app2 get pod,deployments.apps,service,statefulsets.apps
NAME                                    READY   STATUS    RESTARTS   AGE
pod/frontend-backend-6677bb5789-mxt5w   2/2     Running   0          116s
pod/postgres-0                          1/1     Running   0          115s

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/frontend-backend   1/1     1            1           116s

NAME                       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)           AGE
service/frontend-backend   ClusterIP   10.233.40.85    <none>        80/TCP,9000/TCP   116s
service/postgres           ClusterIP   10.233.60.103   <none>        5432/TCP          116s

NAME                        READY   AGE
statefulset.apps/postgres   1/1     116s
```

