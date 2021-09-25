1. При запросе получаем код ответа `HTTP/1.1 301 Moved Permanently`, означает что запрошенный ресурс был окончательно перемещён в URL, указанный в заголовке Location, в нашем случае это https://stackoverflow.com/questions.  
2. Первый код ответа получаем 200, дольше всего обрабатывался запрос `google-analytics_analytics.js?secret=wdgtro` - скрин https://disk.yandex.ru/i/Z3H57nH24yEkOA  
3. 93.81.207.200  
4. Вывод whois  
```commandline
[jekis_@fedora ~]$ whois -h whois.radb.net 93.81.207.200
[Querying whois.radb.net]
[whois.radb.net]
route:          93.81.207.0/24
descr:          RU-CORBINA-BROADBAND-POOL10
origin:         AS8402
mnt-by:         RU-CORBINA-MNT
notify:         noc@corbina.net
created:        2011-09-26T15:00:05Z
last-modified:  2011-09-26T15:00:05Z
source:         RIPE
remarks:        ****************************
remarks:        * THIS OBJECT IS MODIFIED
remarks:        * Please note that all data that is generally regarded as personal
remarks:        * data has been removed from this object.
remarks:        * To view the original object, please query the RIPE Database at:
remarks:        * http://www.ripe.net/whois
remarks:        ****************************
```
5. Вывод traceroute  
```commandline
[jekis_@fedora ~]$ traceroute -An 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  192.168.1.1 [*]  1.465 ms  1.523 ms  3.887 ms
 2  100.129.0.1 [AS21928]  6.605 ms  6.551 ms  8.894 ms
 3  * * *
 4  * * *
 5  85.21.224.191 [AS8402]  9.146 ms  9.511 ms  9.821 ms
 6  72.14.198.182 [AS15169]  8.277 ms *  4.679 ms
 7  * 142.251.49.158 [AS15169]  16.987 ms *
 8  108.170.250.66 [AS15169]  4.678 ms 64.233.174.218 [AS15169]  7.101 ms 108.170.250.83 [AS15169]  4.994 ms
 9  108.170.250.83 [AS15169]  4.988 ms 172.253.51.245 [AS15169]  20.397 ms 142.251.49.24 [AS15169]  19.622 ms
10  209.85.255.136 [AS15169]  21.941 ms 216.239.48.224 [AS15169]  16.673 ms 209.85.254.6 [AS15169]  22.374 ms
11  * 216.239.43.20 [AS15169]  18.555 ms 108.170.235.64 [AS15169]  21.783 ms
12  216.239.54.201 [AS15169]  22.698 ms * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  8.8.8.8 [AS15169]  23.648 ms  23.692 ms *
```
6. Вывод mtr. Судя по выводу наибольшая задержка происходит на 9ом и 11ом хопе.  
```commandline
                                                                         My traceroute  [v0.94]
fedora (192.168.1.40) -> 8.8.8.8 (8.8.8.8)                                                                                                     2021-09-25T21:40:40+0300
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                                                                                                               Packets               Pings
 Host                                                                                                                        Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. AS???    192.168.1.1                                                                                                      0.0%    75    1.2   2.9   1.1  24.7   3.3
 2. AS21928  100.129.0.1                                                                                                      0.0%    75    4.2   5.0   2.7  32.3   4.3
 3. (waiting for reply)
 4. (waiting for reply)
 5. (waiting for reply)
 6. AS15169  72.14.198.182                                                                                                    0.0%    75    9.5   6.9   4.1  36.0   4.4
 7. AS15169  108.170.250.33                                                                                                   0.0%    75    7.5  10.1   7.4  46.7   6.4
 8. AS15169  108.170.250.34                                                                                                   0.0%    75   13.4  10.0   7.0  73.1   8.4
 9. AS15169  172.253.66.116                                                                                                   4.0%    75   19.6  21.9  18.6  64.0   7.4
10. AS15169  172.253.65.159                                                                                                   0.0%    75   18.2  24.5  18.0  66.0   9.9
11. AS15169  216.239.48.85                                                                                                    0.0%    75   20.3  22.3  19.7  43.6   4.4
12. (waiting for reply)
```
7. DNS сервера гугла:  
```commandline
;; QUESTION SECTION:
;dns.google.			IN	A

;; ANSWER SECTION:
dns.google.		2912	IN	A	8.8.4.4
dns.google.		2912	IN	A	8.8.8.8
```
8. DNS entry 8.8.8.8
```commandline
;; QUESTION SECTION:
;8.8.8.8.in-addr.arpa.		IN	PTR

;; ANSWER SECTION:
8.8.8.8.in-addr.arpa.	5586	IN	PTR	dns.google.
```