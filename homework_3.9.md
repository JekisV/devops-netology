1. https://disk.yandex.ru/i/1B7uCHgFlL291Q  

2. https://disk.yandex.ru/i/5K1nS4FqLTsBrA  

3. https://disk.yandex.ru/i/9R4yJhUb8Ho9KA  

4. *Проверьте на TLS уязвимости произвольный сайт в интернете*:  
```commandline
 Start 2021-10-01 22:15:31        -->> 87.250.250.242:443 (www.ya.ru) <<--

 Further IP addresses:   2a02:6b8::2:242 
 rDNS (87.250.250.242):  ya.ru.
 Service detected:       HTTP


 Testing protocols via sockets except NPN+ALPN 

 SSLv2      not offered (OK)
 SSLv3      not offered (OK)
 TLS 1      offered (deprecated)
 TLS 1.1    offered (deprecated)
 TLS 1.2    offered (OK)
 TLS 1.3    offered (OK): final
 NPN/SPDY   not offered
 ALPN/HTTP2 http/1.1 (offered)
```

5. SSH connect via ssh-key:  
```commandline
jekis_@Lnx:~$ ssh-keygen 
Generating public/private rsa key pair.
Enter file in which to save the key (/home/jekis_/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/jekis_/.ssh/id_rsa
Your public key has been saved in /home/jekis_/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:HC8LExJ1us1/C9Ex2zAJdAVSK8xa5T+vo1EI/064Oow jekis_@Lnx
The key's randomart image is:
+---[RSA 3072]----+
|    ... ..+.=o.  |
|     . o o * o   |
|    . o . * O    |
|     . * = = X   |
|      + S o = =  |
|       o + . + o |
|        .oo + o .|
|        E oo *.. |
|          .o+.o. |
+----[SHA256]-----+
jekis_@Lnx:~$ ssh-copy-id jekis_@192.168.1.40
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/jekis_/.ssh/id_rsa.pub"
The authenticity of host '192.168.1.40 (192.168.1.40)' can't be established.
ECDSA key fingerprint is SHA256:6Ko1eHEVUBvmaizVivVzMIIvofY72Ysg+RSI6VVdoqk.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
jekis_@192.168.1.40's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'jekis_@192.168.1.40'"
and check to make sure that only the key(s) you wanted were added.

jekis_@Lnx:~$ ssh 'jekis_@192.168.1.40'
Last login: Wed Sep 22 23:10:32 2021
```

6. SSH login other host via ssh config file:  
```commandline
jekis_@Lnx:~$ cat .ssh/config 
Host fedora
User jekis_
IdentityFile ~/.ssh/fedora
Protocol 2
jekis_@Lnx:~$ ssh fedora
Last login: Sat Oct  2 01:38:18 2021 from 192.168.1.80
```

7. *Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов.*:  
```commandline
[root@fedora jekis_]# tcpdump -c 100 -w 0001.pcap
dropped privs to tcpdump
tcpdump: listening on wlp2s0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
100 packets captured
241 packets received by filter
0 packets dropped by kernel
```
*Откройте файл pcap в Wireshark*.:  
https://disk.yandex.ru/i/7Ral1jKO0Om2kQ  

8. *Просканируйте хост scanme.nmap.org. Какие сервисы запущены?*:  
```commandline
[root@fedora jekis_]# nmap -sR scanme.nmap.org
WARNING: -sR is now an alias for -sV and activates version detection as well as RPC scan.
Starting Nmap 7.80 ( https://nmap.org ) at 2021-10-02 02:00 MSK
Nmap scan report for scanme.nmap.org (45.33.32.156)
Host is up (0.19s latency).
Other addresses for scanme.nmap.org (not scanned): 2600:3c01::f03c:91ff:fe18:bb2f
Not shown: 996 closed ports
PORT      STATE SERVICE    VERSION
22/tcp    open  ssh        OpenSSH 6.6.1p1 Ubuntu 2ubuntu2.13 (Ubuntu Linux; protocol 2.0)
80/tcp    open  http       Apache httpd 2.4.7 ((Ubuntu))
9929/tcp  open  nping-echo Nping echo
31337/tcp open  tcpwrapped
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 11.57 seconds
```
9. *Установите и настройте фаервол ufw на web-сервер из задания 3. Откройте доступ снаружи только к портам 22,80,443.*:  
```commandline
root@vagrant:/home/vagrant/testssl.sh# ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp (OpenSSH)           ALLOW IN    Anywhere                  
80,443/tcp (Apache Full)   ALLOW IN    Anywhere                  
22/tcp (OpenSSH (v6))      ALLOW IN    Anywhere (v6)             
80,443/tcp (Apache Full (v6)) ALLOW IN    Anywhere (v6)
```
