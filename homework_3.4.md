1. Создаем сервис, затем рестартуем демон, рестартуем сам сервис, проверяем статус сервиса, добавляем его в автозагрузку и смотрим содержимое файла node_exporter.service: 
```commandline
root@vagrant:/etc/systemd/system# vim node_exporter.service 
root@vagrant:/etc/systemd/system# systemctl daemon-reload
root@vagrant:/etc/systemd/system# systemctl restart node_exporter.service
root@vagrant:/etc/systemd/system# systemctl enable node_exporter.service 
Created symlink /etc/systemd/system/multi-user.target.wants/node_exporter.service → /etc/systemd/system/node_exporter.service. 
root@vagrant:/etc/systemd/system# systemctl status node_exporter.service 
● node_exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Thu 2021-09-16 14:47:50 UTC; 5s ago
   Main PID: 1709 (node_exporter)
      Tasks: 5 (limit: 1071)
     Memory: 2.3M
     CGroup: /system.slice/node_exporter.service
             └─1709 /opt/node/node_exporter

Sep 16 14:47:50 vagrant node_exporter[1709]: level=info ts=2021-09-16T14:47:50.597Z caller=node_exporter.go:115 collector=thermal_zone
Sep 16 14:47:50 vagrant node_exporter[1709]: level=info ts=2021-09-16T14:47:50.597Z caller=node_exporter.go:115 collector=time
Sep 16 14:47:50 vagrant node_exporter[1709]: level=info ts=2021-09-16T14:47:50.597Z caller=node_exporter.go:115 collector=timex
Sep 16 14:47:50 vagrant node_exporter[1709]: level=info ts=2021-09-16T14:47:50.598Z caller=node_exporter.go:115 collector=udp_queues
Sep 16 14:47:50 vagrant node_exporter[1709]: level=info ts=2021-09-16T14:47:50.598Z caller=node_exporter.go:115 collector=uname
Sep 16 14:47:50 vagrant node_exporter[1709]: level=info ts=2021-09-16T14:47:50.598Z caller=node_exporter.go:115 collector=vmstat
Sep 16 14:47:50 vagrant node_exporter[1709]: level=info ts=2021-09-16T14:47:50.598Z caller=node_exporter.go:115 collector=xfs
Sep 16 14:47:50 vagrant node_exporter[1709]: level=info ts=2021-09-16T14:47:50.598Z caller=node_exporter.go:115 collector=zfs
Sep 16 14:47:50 vagrant node_exporter[1709]: level=info ts=2021-09-16T14:47:50.598Z caller=node_exporter.go:199 msg="Listening on" address=:9100
Sep 16 14:47:50 vagrant node_exporter[1709]: level=info ts=2021-09-16T14:47:50.599Z caller=tls_config.go:191 msg="TLS is disabled." http2=false
root@vagrant:/etc/systemd/system# cat node_exporter.service 
[Unit]
Description=Node Exporter

[Service]
EnvironmentFile=/opt/node/exporter_
ExecStart=/opt/node/node_exporter $OPTIONS

[Install]
WantedBy=multi-user.target
root@vagrant:/etc/systemd/system# cat /opt/node/exporter_ 
--collector.cpu.info
--collector.uname
   ```
Не смог разобраться с подзаданием "предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на systemctl cat cron)", не смог понять, как я должен передавать параметры запуска, в файле параметры прописаны, но не понятно, считываются они при запуске или нет. В этом моменте мне требуется помощь преподавателя!  
Сервис после ребута вм поднимается и работает.
2. CPU:  
```commandline
# TYPE node_cpu_seconds_total counter
node_cpu_seconds_total{cpu="0",mode="idle"} 6885
node_cpu_seconds_total{cpu="0",mode="iowait"} 7.89
node_cpu_seconds_total{cpu="0",mode="irq"} 0
node_cpu_seconds_total{cpu="0",mode="nice"} 0.13
node_cpu_seconds_total{cpu="0",mode="softirq"} 2.98
node_cpu_seconds_total{cpu="0",mode="steal"} 0
node_cpu_seconds_total{cpu="0",mode="system"} 7.51
node_cpu_seconds_total{cpu="0",mode="user"} 6.64
node_cpu_seconds_total{cpu="1",mode="idle"} 6886.43
node_cpu_seconds_total{cpu="1",mode="iowait"} 6.73
node_cpu_seconds_total{cpu="1",mode="irq"} 0
node_cpu_seconds_total{cpu="1",mode="nice"} 0.08
node_cpu_seconds_total{cpu="1",mode="softirq"} 1.39
node_cpu_seconds_total{cpu="1",mode="steal"} 0
node_cpu_seconds_total{cpu="1",mode="system"} 6.34
node_cpu_seconds_total{cpu="1",mode="user"} 5.59
```
Memory:  
```commandline
# TYPE node_memory_MemAvailable_bytes gauge
node_memory_MemAvailable_bytes 6.78715392e+08
# HELP node_memory_MemFree_bytes Memory information field MemFree_bytes.
# TYPE node_memory_MemFree_bytes gauge
node_memory_MemFree_bytes 2.10059264e+08
# HELP node_memory_MemTotal_bytes Memory information field MemTotal_bytes.
# TYPE node_memory_MemTotal_bytes gauge
node_memory_MemTotal_bytes 1.028694016e+09
```
Disk:
```commandline
# TYPE node_disk_io_time_seconds_total counter
node_disk_io_time_seconds_total{device="dm-0"} 26.94
node_disk_io_time_seconds_total{device="dm-1"} 0.048
node_disk_io_time_seconds_total{device="sda"} 27.080000000000002
# TYPE node_disk_read_time_seconds_total counter
node_disk_read_time_seconds_total{device="dm-0"} 31.672
node_disk_read_time_seconds_total{device="dm-1"} 0.036000000000000004
node_disk_read_time_seconds_total{device="sda"} 20.57
# TYPE node_disk_read_time_seconds_total counter
node_disk_read_time_seconds_total{device="dm-0"} 31.672
node_disk_read_time_seconds_total{device="dm-1"} 0.036000000000000004
node_disk_read_time_seconds_total{device="sda"} 20.57
```
Network:
```commandline
# TYPE node_network_receive_bytes_total counter
node_network_receive_bytes_total{device="eth0"} 1.286704e+06
node_network_receive_bytes_total{device="lo"} 378
# TYPE node_network_transmit_bytes_total counter
node_network_transmit_bytes_total{device="eth0"} 402258
node_network_transmit_bytes_total{device="lo"} 378
```
3. ![Netdata](https://disk.yandex.ru/i/aTREjTe_71jkYw)  
4. Да, можно:
```commandline
vagrant@vagrant:~$ dmesg | grep virt
[    0.001843] CPU MTRRs all blank - virtualized system.
[    0.086733] Booting paravirtualized kernel on KVM
[    2.828354] systemd[1]: Detected virtualization oracle.
vagrant@vagrant:~
```
5. Это системное ограничение на количество открытых дискрипторов в системе для одного пользователя.
```commandline
vagrant@vagrant:~$ sysctl fs.nr_open
fs.nr_open = 1048576
```
*Какой другой существующий лимит не позволит достичь такого числа?*  
Не совсем понятен вопрос, что именно подразумевается? если задавать жестко, то `ulimit -Hn`, если ограниченно то `ulimit -Sn`. Жесткий лимит не может быть больше числа заданным системой.  
6. 
```commandline
root@vagrant:/home/vagrant# ps aux | grep sleep
root        1445  0.0  0.0   8076   592 pts/0    S+   16:20   0:00 sleep 1h
root        1595  0.0  0.0   8900   736 pts/1    S+   16:27   0:00 grep --color=auto sleep
root@vagrant:/home/vagrant# nsenter -t 1445 -m -p
root@vagrant:/# ps
    PID TTY          TIME CMD
   1578 pts/1    00:00:00 sudo
   1579 pts/1    00:00:00 su
   1580 pts/1    00:00:00 bash
   1596 pts/1    00:00:00 nsenter
   1597 pts/1    00:00:00 bash
   1610 pts/1    00:00:00 ps
root@vagrant:/#
```
7. `[ 2757.642242] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-5.scope`  
контроллер пидов помог стабилизировать систему.  
командой `ulimit -u 10` - число процессов будет ограниченно 10 для пользователей.