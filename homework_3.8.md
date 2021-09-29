1. Поиск маршрута к моему public IP:  
```commandline
route-views>show ip route 93.81.207.200 
Routing entry for 93.80.0.0/15
  Known via "bgp 6447", distance 20, metric 0
  Tag 3303, type external
  Last update from 217.192.89.50 4d13h ago
  Routing Descriptor Blocks:
  * 217.192.89.50, from 217.192.89.50, 4d13h ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 3303
      MPLS label: none
route-views>show bgp 93.81.207.200
BGP routing table entry for 93.80.0.0/15, version 1037626626
Paths: (24 available, best #15, table default)
...
Refresh Epoch 2
  3303 3216 8402
    217.192.89.50 from 217.192.89.50 (138.187.128.158)
      Origin IGP, localpref 100, valid, external, best
      Community: 3216:1000 3216:1004 3216:1110 3216:2221 3216:5000 3216:5010 3216:5020 3216:5030 3216:5040 3216:5101 3216:5310 3216:5320 3216:5400 3216:5410 3303:1004 3303:1006 3303:1030 3303:3056 8402:900 8402:904 8402:905
      path 7FE18B3BF2C8 RPKI State not found
      rx pathid: 0, tx pathid: 0x0
```
Всю маршрутную таблицу не стал отображать, отобразил только лучший маршрут.  
2. Создайте dummy0 интерфейс в Ubuntu:  
```commandline
root@vagrant:/home/vagrant# cat /etc/network/interfaces
# interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d

auto dummy0
iface dummy0 inet static
address 192.168.0.100/32
pre-up ip link add dummy0 type dummy
post-down ip link del dummy0
root@vagrant:/home/vagrant# ip -br a
lo               UNKNOWN        127.0.0.1/8 ::1/128 
eth0             UP             10.0.2.15/24 fe80::a00:27ff:fe73:60cf/64 
dummy0           UNKNOWN        192.168.0.100/32 fe80::f88c:1dff:fec6:f545/64 
root@vagrant:/home/vagrant# ping 192.168.0.100
PING 192.168.0.100 (192.168.0.100) 56(84) bytes of data.
64 bytes from 192.168.0.100: icmp_seq=1 ttl=64 time=0.044 ms
^C
--- 192.168.0.100 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.044/0.044/0.044/0.000 ms
```
Добавьте несколько статических маршрутов:  
```commandline
root@vagrant:/home/vagrant# ip ro add 192.168.0.0/24 via 10.0.2.15
root@vagrant:/home/vagrant# ip ro add 192.168.0.100/32 via 10.0.2.15
```
Проверьте таблицу маршрутизации:  
```commandline
root@vagrant:/home/vagrant# ip ro sh
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100 
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100 
192.168.0.0/24 via 10.0.2.15 dev eth0 
192.168.0.100 via 10.0.2.15 dev eth0
```
3. Смотрим открытые TCP порты в Ubuntu:  
```commandline
root@vagrant:/home/vagrant# netstat -nltp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:111             0.0.0.0:*               LISTEN      1/init              
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      561/systemd-resolve 
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      785/sshd: /usr/sbin 
tcp6       0      0 :::111                  :::*                    LISTEN      1/init              
tcp6       0      0 :::22                   :::*                    LISTEN      785/sshd: /usr/sbin
```
Видим три открытых порта:  
22 порт - служба SSH;  
111 порт - слушает сервис rpcbind;  
53 порт - локальный порт отвечающий за службы DNS.  
4. Смотрим используемые UDP сокеты в Ubuntu:  
```commandline
root@vagrant:/home/vagrant# netstat -nlup
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
udp        0      0 127.0.0.53:53           0.0.0.0:*                           561/systemd-resolve 
udp        0      0 10.0.2.15:68            0.0.0.0:*                           400/systemd-network 
udp        0      0 0.0.0.0:111             0.0.0.0:*                           1/init              
udp6       0      0 :::111                  :::*                                1/init
```
53 порт - локальный порт отвечающий за службы DNS, служба systemd-resolve;  
68 порт - служба systemd-network, возможно используется для Bootstrap Protocol Client, но я не уверен.  
5. Используя diagrams.net, создайте L3 диаграмму:  
https://disk.yandex.ru/i/PewwtQX8MwZykw
