1. _Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться 
данные БД и бэкапы. Приведите получившуюся команду или docker-compose манифест:_  
```commandline
services:
  pg_db:
    image: postgres:12
    restart: always
    environment:
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_USER=postgres
    volumes:
      - /dbdata:/var/lib/postgresql/data
      - /backup:/var/lib/postgresql/backup
    ports:
      - '0.0.0.0:5432:5432'
```
2. _Приведите итоговый список БД после выполнения пунктов:_  
```commandline
test_db=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)
```
_описание таблиц (describe):_  
```commandline
test_db=# \dt
          List of relations
 Schema |  Name   | Type  |  Owner   
--------+---------+-------+----------
 public | clients | table | postgres
 public | orders  | table | postgres
(2 rows)
```
_SQL-запрос для выдачи списка пользователей с правами над таблицами test_db:_  
```commandline
test_db=# select * from information_schema.table_privileges where grantee in ('test_simple_user','test_admin_user');
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | test_simple_user | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test_simple_user | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test_simple_user | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test_simple_user | test_db       | public       | clients    | DELETE         | NO           | NO
 postgres | test_simple_user | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test_simple_user | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test_simple_user | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test_simple_user | test_db       | public       | orders     | DELETE         | NO           | NO
(8 rows)
```
_список пользователей с правами над таблицами test_db:_  
```commandline
test_db=# \du
                                       List of roles
    Role name     |                         Attributes                         | Member of 
------------------+------------------------------------------------------------+-----------
 postgres         | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 test_admin_user  |                                                            | {}
 test_simple_user |                                                            | {}
```
3. _Используя SQL синтаксис - наполните таблицы следующими тестовыми данными и приведите в ответе
запросы и результат их выполнения:_  
```commandline
test_db=# select * from orders;
 id |  name   | price 
----+---------+-------
  1 | Шоколад |    10
  2 | Принтер |  3000
  3 | Книга   |   500
  4 | Монитор |  7000
  5 | Гитара  |  4000
(5 rows)

test_db=# select * from clients;
 id |       lastname       | country | booking 
----+----------------------+---------+---------
  1 | Иванов Иван Иванович | USA     |        
  2 | Петров Петр Петрович | Canada  |        
  3 | Иоганн Себастьян Бах | Japan   |        
  4 | Ронни Джеймс Дио     | Russia  |        
  5 | Ritchie Blackmore    | Russia  |        
(5 rows)
```
4. _Используя foreign keys свяжите записи из таблиц и приведите SQL-запросы для выполнения данных операций, 
риведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса:_  
```commandline
test_db=# update clients set booking = 3 where id = 1;
UPDATE 1
test_db=# update clients set booking = 4 where id = 2;
UPDATE 1
test_db=# update clients set booking = 5 where id = 3;
UPDATE 1
test_db=# select * from clients where booking is not null;
 id |       lastname       | country | booking 
----+----------------------+---------+---------
  1 | Иванов Иван Иванович | USA     |       3
  2 | Петров Петр Петрович | Canada  |       4
  3 | Иоганн Себастьян Бах | Japan   |       5
(3 rows)
```
5. _Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN). Приведите получившийся результат и объясните что значат полученные значения:_  
```commandline
test_db=# explain select * from clients where booking is not null;
                        QUERY PLAN                         
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
   Filter: (booking IS NOT NULL)
(2 rows)
```
Показывает стоимость (нагрузку на исполнение) запроса, и фильтрацию по полю booking для выборки.  
6. _Приведите список операций, который вы применяли для бэкапа данных и восстановления:_  
```commandline
[root@node01 stack]# docker exec -t 67f853ab7153 pg_dump -U postgres test_db -f /var/lib/postgresql/backup/dump_test_db.sql
[root@node01 stack]# ll /backup/
итого 4
-rw-r--r--. 1 root root 2537 дек 20 13:01 dump_test_db.sql
[root@node01 stack]# docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED       STATUS       PORTS                    NAMES
67f853ab7153   postgres:12   "docker-entrypoint.s…"   2 hours ago   Up 2 hours   0.0.0.0:5432->5432/tcp   stack_pg_db_1
[root@node01 stack]# docker stop 67f853ab7153
[root@node01 stack]# docker run --name stack_pg_db_3 -e POSTGRES_PASSWORD=postgres -v /backup:/var/lib/postgresql/backup/ -d -p 5432:5432 postgres:12
136be68759ee8a6a7e3e1d1f657fab758a36d4b866027e9aa485adef62153ef7
[root@node01 stack]# docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                                       NAMES
136be68759ee   postgres:12   "docker-entrypoint.s…"   21 seconds ago   Up 21 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   stack_pg_db_3
[root@node01 stack]# docker exec -it 136be68759ee psql -U postgres
psql (12.9 (Debian 12.9-1.pgdg110+1))
Type "help" for help.

postgres=# CREATE DATABASE test_db3;
CREATE DATABASE
postgres=# \q
[root@node01 stack]# docker exec -i stack_pg_db_3 psql -U postgres -d test_db3 -f /var/lib/postgresql/backup/dump_test_db.sql
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE TABLE
ALTER TABLE
COPY 5
COPY 5
ALTER TABLE
ALTER TABLE
ALTER TABLE
psql:/var/lib/postgresql/backup/dump_test_db.sql:104: ERROR:  role "test_simple_user" does not exist
psql:/var/lib/postgresql/backup/dump_test_db.sql:111: ERROR:  role "test_simple_user" does not exist
```
