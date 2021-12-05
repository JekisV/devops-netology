1. *В чём отличие режимов работы сервисов в Docker Swarm 
кластере: replication и global?:* - в режиме реплики мы самостоятельно
указываем количество реплик сервисов, не зависимо от количества нод, а в 
режиме глобал сервисы запускаются на каждой ноде автоматически.  
*Какой алгоритм выбора лидера используется в Docker Swarm кластере?* - 
используется так называемый алгоритм поддержания распределенного 
консенсуса — Raft.  
*Что такое Overlay Network?* - overlay-сеть создает подсеть, которую 
могут использовать контейнеры в разных хостах swarm-кластера. Контейнеры 
на разных физических хостах могут обмениваться данными по overlay-сети 
(если все они прикреплены к одной сети).  


2. *Создать ваш первый Docker Swarm кластер в Яндекс.Облаке:*  
```commandline
[root@node01 centos]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
erz4s4t3873x444jx2vmjftsl *   node01.netology.yc   Ready     Active         Leader           20.10.11
x5up0mcbxf4vtks2ncl1mfnw0     node02.netology.yc   Ready     Active         Reachable        20.10.11
fo9uvnscmglsfh4vbodextf32     node03.netology.yc   Ready     Active         Reachable        20.10.11
d4840xc7e1o6ru6iilwlw93yn     node04.netology.yc   Ready     Active                          20.10.11
mr070x2w641qjweehvem69y9r     node05.netology.yc   Ready     Active                          20.10.11
g14sybk0680kikb7ys7ts4en0     node06.netology.yc   Ready     Active                          20.10.11
```


3. *Создать ваш первый, готовый к боевой эксплуатации кластер 
мониторинга, состоящий из стека микросервисов:*  
```commandline
[root@node01 centos]# docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
ydu5x99i9uo8   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0    
ne8nhzkwgvrf   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
on41z41agbl7   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest                         
ltsjshljavv7   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest                      
amxlf70u0bqq   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4           
t91bx6ah7jiy   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0   
smnfnzw2e5gn   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0       
r8eufvd9iwda   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
```

4. *Выполнить на лидере Docker Swarm кластера команду и дать письменное описание её функционала, что 
она делает и зачем она нужна:*  
данная команда включает автоблокировку (шифрования и дешифрования) 
журналов RAFT существующего кластера docker-swarm для повышения 
безопасности кластера. Данный ключ загружается в память каждого 
узла менеджера.
