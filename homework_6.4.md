**1**. Найдите и приведите управляющие команды для:

_вывода списка БД_  
```commandline
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)
```
_подключения к БД_  
```commandline
postgres=# \c
You are now connected to database "postgres" as user "postgres".
### Тут я уже подключен к базе, но если бы была другая база, то при помощи этой команды 
### можно произвести переключение БД.
```
_вывода списка таблиц_  
```commandline
postgres=# \dtS
                    List of relations
   Schema   |          Name           | Type  |  Owner   
------------+-------------------------+-------+----------
 pg_catalog | pg_aggregate            | table | postgres
 pg_catalog | pg_am                   | table | postgres
 pg_catalog | pg_amop                 | table | postgres
 pg_catalog | pg_amproc               | table | postgres
 ###  \dt в таблицах пусто , исползовал оп параметр S - для системных объектов
```
_вывода описания содержимого таблиц_  
```commandline
postgres=# \dS+ pg_am
                                  Table "pg_catalog.pg_am"
  Column   |  Type   | Collation | Nullable | Default | Storage | Stats target | Description 
-----------+---------+-----------+----------+---------+---------+--------------+-------------
 oid       | oid     |           | not null |         | plain   |              | 
 amname    | name    |           | not null |         | plain   |              | 
 amhandler | regproc |           | not null |         | plain   |              | 
 amtype    | "char"  |           | not null |         | plain   |              | 
Indexes:
    "pg_am_name_index" UNIQUE, btree (amname)
    "pg_am_oid_index" UNIQUE, btree (oid)
Access method: heap
```
_выхода из psql_  
```commandline
\q
```
**2.** _Приведите в ответе команду, которую вы использовали для вычисления и полученный результат:_  
```commandline
test_database=# select avg_width from pg_stats where tablename='orders';
 avg_width 
-----------
         4
        16
         4
(3 rows)
```
**3.** _Предложите SQL-транзакцию для проведения данной операции:_  
```commandline
postgres=# \c test_database 
You are now connected to database "test_database" as user "postgres".
test_database=# alter table orders rename to orders_new;
ALTER TABLE
test_database=# create table orders (id integer, title varchar(80), price integer) partition by range(price);
CREATE TABLE
test_database=# create table orders_less499 partition of orders for values from (0) to (499);
CREATE TABLE
test_database=# create table orders_more499 partition of orders for values from (499) to (999999999);
CREATE TABLE
test_database=# insert into orders (id, title, price) select * from orders_new;
INSERT 0 8
test_database=# \dt
                   List of relations
 Schema |      Name      |       Type        |  Owner   
--------+----------------+-------------------+----------
 public | orders         | partitioned table | postgres
 public | orders_less499 | table             | postgres
 public | orders_more499 | table             | postgres
 public | orders_new     | table             | postgres
(4 rows)

test_database=# select * from orders_new;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  2 | My little database   |   500
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  6 | WAL never lies       |   900
  7 | Me and my bash-pet   |   499
  8 | Dbiezdmin            |   501
(8 rows)

test_database=# select * from orders_less499;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
(4 rows)

test_database=# select * from orders_more499;
 id |       title        | price 
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  7 | Me and my bash-pet |   499
  8 | Dbiezdmin          |   501
(4 rows)
```
_Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?:_  
Да, при изначальном проектированиии таблиц можно было сделать ее секционированной, тогда 
не пришлось бы переименовывать исходную таблицу и переносить данные в новую.  

**4.**  _Используя утилиту pg_dump создайте бекап БД test_database:_  
```commandline
[root@node01 ~]# docker exec -i f30c01be1ced pg_dump -U postgres test_database -f /var/lib/postgresql/backup/dump_testdb_psql13.sql
```
_Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца 
title для таблиц test_database?_  
Для уникальности можно добавить индекс или первичный ключ:  
    **CREATE INDEX ON orders ((lower(title)));**