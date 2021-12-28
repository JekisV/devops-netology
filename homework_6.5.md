**1**. _Текст Dockerfile манифеста:_  
```dockerfile
FROM centos:7
LABEL ElasticSearch:7.16.2 created by Jekis_

ENV PATH=/usr/lib:/usr/lib/jvm/jre-11/bin:$PATH

RUN yum update -y && \
    yum install wget -y && \
    yum install java-11-openjdk -y && \
    yum install perl-Digest-SHA -y && \
    yum clean all

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.2-linux-x86_64.tar.gz && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.2-linux-x86_64.tar.gz.sha512 && \
    shasum -a 512 -c elasticsearch-7.16.2-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-7.16.2-linux-x86_64.tar.gz && \
    rm -f elasticsearch-7.16.2-linux-x86_64.tar.gz

ADD elasticsearch.yml /elasticsearch-7.16.2/config/

ENV JAVA_HOME=/elasticsearch-7.16.2/jdk/
ENV ES_HOME=/elasticsearch-7.16.2

RUN groupadd elasticsearch && \
    useradd -g elasticsearch elasticsearch

RUN mkdir /var/lib/logs && \
    chown elasticsearch:elasticsearch /var/lib/logs && \
    mkdir /var/lib/data && \
    chown elasticsearch:elasticsearch /var/lib/data && \
    chown -R elasticsearch:elasticsearch /elasticsearch-7.16.2/ && \
    mkdir /elasticsearch-7.16.2/snapshots && \
    chown elasticsearch:elasticsearch /elasticsearch-7.16.2/snapshots

EXPOSE 9200 9300

USER elasticsearch
CMD ["/usr/sbin/init"]
CMD ["/elasticsearch-7.16.2/bin/elasticsearch"]
```
_Ссылку на образ в репозитории dockerhub:_  
https://hub.docker.com/r/jekisv/elasticsearch/tags  

_Ответ elasticsearch на запрос пути `/` в json виде:_
```json
{
  "name" : "netology_test",
  "cluster_name" : "netology_test_cluster",
  "cluster_uuid" : "QJECfcWSSxqZ7dDBr2vO0w",
  "version" : {
    "number" : "7.16.2",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "2b937c44140b6559905130a8650c64dbd0879cfb",
    "build_date" : "2021-12-18T19:42:46.604893745Z",
    "build_snapshot" : false,
    "lucene_version" : "8.10.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```
**2**. _Получите список индексов и их статусов,
используя API и приведите в ответе на задание:_  
```commandline
[root@node01 ~]# curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases BKA9lXPuTeyQIvZEeIFTXQ   1   0         43            0     40.8mb         40.8mb
green  open   ind-1            cA4Fgt1wRnquYf7QAJ2lcg   1   0          0            0       226b           226b
yellow open   ind-3            TiA-REUdQBiTRaZrhACqVA   4   2          0            0       904b           904b
yellow open   ind-2            NyPa2BrlTLm5dYO3pzMcUg   2   1          0            0       452b           452b
```
_Получите состояние кластера elasticsearch, используя API:_  
```commandline
[root@node01 ~]# curl -X GET "localhost:9200/_cluster/health?pretty"
{
  "cluster_name" : "netology_test_cluster",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 3,
  "active_shards" : 3,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
```
_Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?:_  
Потому что реплицируемые шарды находятся в состоянии unassigned, т.к. в
данной схеме всего одна нода, и реплицировать эти шарды попросту некуда.  

**3.** _Приведите в ответе запрос API и результат вызова API для создания репозитория:_  
```commandline
[root@node01 ~]# curl -X PUT "http://localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
> {
> "type": "fs",
> "settings": {
> "location": "netology_backup"
> }
> }
> '
{
  "acknowledged" : true
}
[root@node01 ~]# curl -X GET http://localhost:9200/_snapshot/netology_backup?pretty
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "netology_backup"
    }
  }
}
```
_Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов:_  
```commandline
[root@node01 ~]# curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases xYgtprReSDOmPSNaOIS4zg   1   0         43            0     40.8mb         40.8mb
green  open   test             m2JNK0eYQNGF5BtgUgAFhQ   1   0          0            0       226b           226b
[root@node01 ~]# curl -X GET http://localhost:9200/test?pretty
{
  "test" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "test",
        "creation_date" : "1640700381496",
        "number_of_replicas" : "0",
        "uuid" : "m2JNK0eYQNGF5BtgUgAFhQ",
        "version" : {
          "created" : "7160299"
        }
      }
    }
  }
}
```
_Приведите в ответе список файлов в директории со снапшотами:_  
```commandline
[elasticsearch@a7ab80b42f3b netology_backup]$ pwd
/elasticsearch-7.16.2/snapshots/netology_backup
[elasticsearch@a7ab80b42f3b netology_backup]$ ll
total 44
-rw-r--r--. 1 elasticsearch elasticsearch  1422 Dec 28 14:14 index-0
-rw-r--r--. 1 elasticsearch elasticsearch     8 Dec 28 14:14 index.latest
drwxr-xr-x. 6 elasticsearch elasticsearch   126 Dec 28 14:14 indices
-rw-r--r--. 1 elasticsearch elasticsearch 29229 Dec 28 14:14 meta-8wblcm7jR7u7FcSR6SWxKw.dat
-rw-r--r--. 1 elasticsearch elasticsearch   709 Dec 28 14:14 snap-8wblcm7jR7u7FcSR6SWxKw.dat
```
_Удалите индекс `test` и создайте индекс `test-2`. Приведите в ответе список индексов:_  
```commandline
[root@node01 ~]# curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2           B9WJZeXeRaOVLEOagxXXbQ   1   0          0            0       226b           226b
green  open   .geoip_databases xYgtprReSDOmPSNaOIS4zg   1   0         43            0     40.8mb         40.8mb
```
_Восстановите состояние кластера elasticsearch из snapshot, 
созданного ранее. Приведите в ответе запрос к API восстановления 
и итоговый список индексов:_  
```commandline
[root@node01 ~]# curl -X POST 0:9200/_snapshot/netology_backup/snapshot_1/_restore?pretty
[root@node01 ~]# curl -X GET 0:9200/_cat/indices?v
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test             m2JNK0eYQNGF5BtgUgAFhQ   1   0          0            0       226b           226b
green  open   test-2           WFY-qLPiQye_qZtm00AjPw   1   0          0            0       226b           226b
green  open   .geoip_databases xYgtprReSDOmPSNaOIS4zg   1   0         43            0     40.8mb         40.8mb
```