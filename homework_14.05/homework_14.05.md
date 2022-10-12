### Задача 1: Рассмотрите пример 14.5/example-security-context.yml  


Создание модуля:  
```commandline
root@node1:/home/ubuntu/clokub-homeworks/14.5# kubectl apply -f example-security-context.yml
pod/security-context-demo created
```
Проверка установленных настроек внутри контейнера:  
```commandline
root@node1:/home/ubuntu/clokub-homeworks/14.5# kubectl logs security-context-demo
uid=1000 gid=3000 groups=3000
```
---
### Задача 2 (*): Рассмотрите пример 14.5/example-network-policy.yml  
Создадим deployment на образах hello-node и multitool:  
```commandline
root@node1:/home/ubuntu/clokub-homeworks/14.5# kubectl create deployment multitooltest --image=praqma/network-multitool:alpine-extra
deployment.apps/multitooltest created
root@node1:/home/ubuntu/clokub-homeworks/14.5# kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4
deployment.apps/hello-node created
```
Создадим `service` для данных деплоев:  
[service.yaml](service.yaml)
```commandline
root@node1:/home/ubuntu/clokub-homeworks/14.5# kubectl apply -f service.yaml
service/hello-node created
service/multitool created
```
Проверка доступности из `multitooltest` в `hello-node`:  
```commandline
root@node1:/home/ubuntu/clokub-homeworks/14.5# kubectl exec multitooltest-8588bd9df4-zkrwt -- curl -m1 -s http://10.233.75.5:8080
CLIENT VALUES:
client_address=10.233.75.4
command=GET
real path=/
query=nil
request_version=1.1
request_uri=http://10.233.75.5:8080/

SERVER VALUES:
server_version=nginx: 1.10.0 - lua: 10001

HEADERS RECEIVED:
accept=*/*
host=10.233.75.5:8080
user-agent=curl/7.79.1
BODY:
-no body in request-
```
Проверка доступности из `hello-node` в `multitooltest`:  
```commandline
root@node1:/home/ubuntu/clokub-homeworks/14.5# kubectl exec hello-node-6d5f754cc9-j6stc -- curl -m1 -s http://10.233.75.4:80
Praqma Network MultiTool (with NGINX) - multitooltest-8588bd9df4-zkrwt - 10.233.75.4
```
Добавляем **NetworkPolicy**, которая ограничит доступ `hello-node` только к 
контейнеру `multitooltest` по 80 порту и не будет иметь доступ к другим 
(внешнему миру):  
[networkpolicy.yaml](networkpolicy.yaml)
```commandline
root@node1:/home/ubuntu/clokub-homeworks/14.5# kubectl apply -f networkpolicy.yaml
networkpolicy.networking.k8s.io/test-network-policy created
```
Проверка доступности `hello-node` в `multitooltest` и доступности к 
внешнему миру, после применения **NetworkPolicy**:  
Доступ из `hello-node` в `multitooltest`:
```commandline
root@node1:/home/ubuntu/clokub-homeworks/14.5# kubectl exec hello-node-6d5f754cc9-j6stc -- curl -m1 -s http://10.233.75.4:80
Praqma Network MultiTool (with NGINX) - multitooltest-8588bd9df4-zkrwt - 10.233.75.4
```
Доступ `multitooltest` на внешний под `10.233.75.7:80`:  
```commandline
root@node1:/home/ubuntu# kubectl exec multitooltest-8588bd9df4-zkrwt -- curl -m1 -s http://10.233.75.9:80
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
</html>
```
Доступ `hello-node` на внешний под `10.233.75.7:80`:  
```commandline
root@node1:/home/ubuntu# kubectl exec hello-node-6d5f754cc9-j6stc -- curl -m1 -s http://10.233.75.9:80
command terminated with exit code 28
```
Удалим политику и проверим доступ еще раз:  
```commandline
root@node1:/home/ubuntu/clokub-homeworks/14.5# kubectl delete -f networkpolicy.yaml 
networkpolicy.networking.k8s.io "test-network-policy" deleted
root@node1:/home/ubuntu/clokub-homeworks/14.5# kubectl exec hello-node-6d5f754cc9-j6stc -- curl -m1 -s http://10.233.75.9:80
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
</html>
```
Политика для `hello-node` работает!
