в общем маленько переделал сам сервис, с добвалением пользователя в систему, файл с передаваемыми опциями указал в переменной **EnvironmentFile**  
сейчас конф. файл самого сервиса и файл с передаваемыми опциями выглядит так:  
```commandline
root@vagrant:/home/vagrant# cat /etc/systemd/system/node_exporter.service 
[Unit]
Description=Node Exporter

[Service]
User=node_exporter
EnvironmentFile=/etc/sysconfig/node_exporter
ExecStart=/usr/sbin/node_exporter $OPTIONS

[Install]
WantedBy=multi-user.target
root@vagrant:/home/vagrant# cat /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter

[Service]
User=node_exporter
EnvironmentFile=/etc/sysconfig/node_exporter
ExecStart=/usr/sbin/node_exporter $OPTIONS

[Install]
WantedBy=multi-user.target
root@vagrant:/home/vagrant# cat /etc/sysconfig/node_exporter
OPTIONS="--collector.textfile.directory /opt/node/exporter_"
OPTIONS="--collector.buddyinfo"
OPTIONS="--collector.ethtool"
OPTIONS="--collector.zoneinfo"
OPTIONS="--web.listen-address=":9111""
```  
сам сервис в статусе отображается следующим образом:  
```commandline
root@vagrant:/home/vagrant# systemctl status node_exporter
● node_exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2021-09-21 18:39:38 UTC; 13min ago
   Main PID: 1690 (node_exporter)
      Tasks: 5 (limit: 1071)
     Memory: 5.7M
     CGroup: /system.slice/node_exporter.service
             └─1690 /usr/sbin/node_exporter --web.listen-address=:9111

Sep 21 18:39:38 vagrant node_exporter[1690]: level=info ts=2021-09-21T18:39:38.947Z caller=node_exporter.go:115 collector=thermal_zone
Sep 21 18:39:38 vagrant node_exporter[1690]: level=info ts=2021-09-21T18:39:38.947Z caller=node_exporter.go:115 collector=time
Sep 21 18:39:38 vagrant node_exporter[1690]: level=info ts=2021-09-21T18:39:38.947Z caller=node_exporter.go:115 collector=timex
Sep 21 18:39:38 vagrant node_exporter[1690]: level=info ts=2021-09-21T18:39:38.947Z caller=node_exporter.go:115 collector=udp_queues
Sep 21 18:39:38 vagrant node_exporter[1690]: level=info ts=2021-09-21T18:39:38.948Z caller=node_exporter.go:115 collector=uname
Sep 21 18:39:38 vagrant node_exporter[1690]: level=info ts=2021-09-21T18:39:38.948Z caller=node_exporter.go:115 collector=vmstat
Sep 21 18:39:38 vagrant node_exporter[1690]: level=info ts=2021-09-21T18:39:38.948Z caller=node_exporter.go:115 collector=xfs
Sep 21 18:39:38 vagrant node_exporter[1690]: level=info ts=2021-09-21T18:39:38.948Z caller=node_exporter.go:115 collector=zfs
Sep 21 18:39:38 vagrant node_exporter[1690]: level=info ts=2021-09-21T18:39:38.948Z caller=node_exporter.go:199 msg="Listening on" address=:9111
Sep 21 18:39:38 vagrant node_exporter[1690]: level=info ts=2021-09-21T18:39:38.949Z caller=tls_config.go:191 msg="TLS is disabled." http2=false
```
параметры передаются, потому что дефолтный порт на которой крутится служба 9100, по параметрам передается чтобы служба запускалась на 9111 порту.  
