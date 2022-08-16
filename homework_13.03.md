### Задание 1: проверить работоспособность каждого компонента  
Для проверки работы можно использовать 2 способа: port-forward и exec. 
Используя оба способа, проверьте каждый компонент:  
* сделайте запросы к бекенду;  
* сделайте запросы к фронту;  
* подключитесь к базе данных.  

Проверку буду осуществлять на кластере, развернутом из предыдущего задания:  
```commandline
root@node1:/home/ubuntu# kubectl exec frontend-78849f496b-dzs9k -- curl -s localhost:80
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
root@node1:/home/ubuntu# kubectl exec backend-56df76df5f-66nmq -- curl -s localhost:9000/api/news/1
{"id":1,"title":"title 0","short_description":"small text 0small text 
0small text 0small text 0small text \ 0small text 0small text 0small 
text 0small text 0small text 0","description":"0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 0 some more 
text, 0 some more text, 0 some more text, 0 some more text, 
","preview":"/static/image.png"}
root@node1:/home/ubuntu# kubectl exec -ti mt-fbf46d456-9xgx4 -- psql postgres://postgres:postgres@postgres:5432/news
psql (13.4, server 13.8)
Type "help" for help.

news=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 news      | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(4 rows)

news=# \d
             List of relations
 Schema |    Name     |   Type   |  Owner   
--------+-------------+----------+----------
 public | news        | table    | postgres
 public | news_id_seq | sequence | postgres
(2 rows)

news=# \q
root@node1:/home/ubuntu# curl localhost:8000/detail/1/
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Детальная</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <article class="b-page js-item"></article>
    <script src="/build/main.js"></script>
</body>
root@node1:/home/ubuntu# kubectl port-forward frontend-78849f496b-dzs9k 8000:80
Forwarding from 127.0.0.1:8000 -> 80
Forwarding from [::1]:8000 -> 80
Handling connection for 8000
root@node1:/home/ubuntu# curl localhost:9000/api/news/
[{"id":1,"title":"title 0","short_description":"small text 0small text 0small ......
root@node1:/home/ubuntu# kubectl port-forward backend-56df76df5f-66nmq 9000:9000
Forwarding from 127.0.0.1:9000 -> 9000
Forwarding from [::1]:9000 -> 9000
Handling connection for 9000
```
Проверка выполнена!  

---
### Задание 2: ручное масштабирование  
При работе с приложением иногда может потребоваться вручную добавить 
пару копий. Используя команду `kubectl scale`, попробуйте увеличить 
количество бекенда и фронта до 3. Проверьте, на каких нодах оказались 
копии после каждого действия (`kubectl describe`, `kubectl get pods -o 
wide`). После уменьшите количество копий до 1.  
```commandline
root@node1:/home/ubuntu# kubectl scale --replicas=3 deployment backend
deployment.apps/backend scaled
root@node1:/home/ubuntu# kubectl scale --replicas=3 deployment frontend
deployment.apps/frontend scaled
root@node1:/home/ubuntu# kubectl get pods -o wide
NAME                        READY   STATUS    RESTARTS   AGE    IP               NODE    NOMINATED NODE   READINESS GATES
backend-56df76df5f-66nmq    1/1     Running   0          24m    10.233.102.138   node1   <none>           <none>
backend-56df76df5f-g69q8    1/1     Running   0          38s    10.233.102.139   node1   <none>           <none>
backend-56df76df5f-xqgld    1/1     Running   0          38s    10.233.75.5      node2   <none>           <none>
frontend-78849f496b-6xhfb   1/1     Running   0          30s    10.233.102.140   node1   <none>           <none>
frontend-78849f496b-dzs9k   1/1     Running   0          23h    10.233.102.134   node1   <none>           <none>
frontend-78849f496b-wjl8m   1/1     Running   0          30s    10.233.75.6      node2   <none>           <none>
mt-fbf46d456-9xgx4          1/1     Running   0          172m   10.233.102.135   node1   <none>           <none>
mt-fbf46d456-vxvg8          1/1     Running   0          172m   10.233.75.4      node2   <none>           <none>
postgres-0                  1/1     Running   0          23h    10.233.102.132   node1   <none>           <none>
root@node1:/home/ubuntu# kubectl scale --replicas=1 deployment backend
deployment.apps/backend scaled
root@node1:/home/ubuntu# kubectl scale --replicas=1 deployment frontend
deployment.apps/frontend scaled
root@node1:/home/ubuntu# kubectl get pods -o wide
NAME                        READY   STATUS    RESTARTS   AGE     IP               NODE    NOMINATED NODE   READINESS GATES
backend-56df76df5f-xqgld    1/1     Running   0          4m58s   10.233.75.5      node2   <none>           <none>
frontend-78849f496b-wjl8m   1/1     Running   0          4m50s   10.233.75.6      node2   <none>           <none>
mt-fbf46d456-9xgx4          1/1     Running   0          177m    10.233.102.135   node1   <none>           <none>
mt-fbf46d456-m6jsb          1/1     Running   0          4s      10.233.75.7      node2   <none>           <none>
postgres-0                  1/1     Running   0          23h     10.233.102.132   node1   <none>           <none>
```
Done!!!