**1.** _Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД:_  
```commandline
mysql> \s
--------------
mysql  Ver 8.0.27 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		14
Current database:	test_db
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.27 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			43 min 51 sec

Threads: 2  Questions: 65  Slow queries: 0  Opens: 161  Flush tables: 3  Open tables: 79  Queries per second avg: 0.024
--------------
```
_Подключитесь к восстановленной БД и получите список таблиц из этой БД:_  
```commandline
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)
```
_Приведите в ответе количество записей с price > 300:_  
```commandline
mysql> select * from orders where price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)
```
**2.** _Создайте пользователя test в БД c паролем test-pass:_  
```commandline
mysql> CREATE USER 'test'@'localhost'
    -> IDENTIFIED WITH mysql_native_password BY 'test-pass'
    -> WITH MAX_QUERIES_PER_HOUR 100
    -> PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3
    -> ATTRIBUTE '{"fname": "James", "lname": "Pretty"}';
Query OK, 0 rows affected (0.01 sec)
```
_Предоставьте привелегии пользователю test на операции SELECT базы test_db:_  
```commandline
mysql> GRANT Select ON test_db.orders TO 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.01 sec)
```
_Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test:_  
```commandline
mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)
```
**3.** _Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES;:_  
```commandline
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> SHOW PROFILES;
+----------+------------+-------------------+
| Query_ID | Duration   | Query             |
+----------+------------+-------------------+
|        1 | 0.00019200 | SET profiling = 1 |
+----------+------------+-------------------+
1 row in set, 1 warning (0.00 sec)
```
_Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе:_  
```commandline
mysql> select TABLE_NAME,ENGINE,ROW_FORMAT,TABLE_ROWS,DATA_LENGTH FROM information_schema.TABLES WHERE table_name = 'orders' and TABLE_SCHEMA = 'test_db';
+------------+--------+------------+------------+-------------+
| TABLE_NAME | ENGINE | ROW_FORMAT | TABLE_ROWS | DATA_LENGTH |
+------------+--------+------------+------------+-------------+
| orders     | InnoDB | Dynamic    |          5 |       16384 |
+------------+--------+------------+------------+-------------+
1 row in set (0.00 sec)
```
В таблице БД test_db используется engine InnoDB.  

_Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:_  
```commandline
mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.05 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> select TABLE_NAME,ENGINE,ROW_FORMAT,TABLE_ROWS,DATA_LENGTH FROM information_schema.TABLES WHERE table_name = 'orders' and TABLE_SCHEMA = 'test_db';
+------------+--------+------------+------------+-------------+
| TABLE_NAME | ENGINE | ROW_FORMAT | TABLE_ROWS | DATA_LENGTH |
+------------+--------+------------+------------+-------------+
| orders     | MyISAM | Dynamic    |          5 |       16384 |
+------------+--------+------------+------------+-------------+
1 row in set (0.00 sec)

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.06 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> select TABLE_NAME,ENGINE,ROW_FORMAT,TABLE_ROWS,DATA_LENGTH FROM information_schema.TABLES WHERE table_name = 'orders' and TABLE_SCHEMA = 'test_db';
+------------+--------+------------+------------+-------------+
| TABLE_NAME | ENGINE | ROW_FORMAT | TABLE_ROWS | DATA_LENGTH |
+------------+--------+------------+------------+-------------+
| orders     | InnoDB | Dynamic    |          5 |       16384 |
+------------+--------+------------+------------+-------------+
1 row in set (0.01 sec)

mysql> show profiles;
+----------+------------+----------------------------------------------------------------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                                                                              |
+----------+------------+----------------------------------------------------------------------------------------------------------------------------------------------------+
|        1 | 0.00019200 | SET profiling = 1                                                                                                                                  |
|        2 | 0.00556425 | show table status                                                                                                                                  |
|        3 | 0.00136550 | show table status                                                                                                                                  |
|        4 | 0.00110075 | select TABLE_NAME,ENGINE,ROW_FORMAT,TABLE_ROWS,DATA_LENGTH FROM information_schema.TABLES WHERE table_name = 'orders' and TABLE_SCHEMA = 'test_db' |
|        5 | 0.05451300 | ALTER TABLE orders ENGINE = MyISAM                                                                                                                 |
|        6 | 0.00149025 | select TABLE_NAME,ENGINE,ROW_FORMAT,TABLE_ROWS,DATA_LENGTH FROM information_schema.TABLES WHERE table_name = 'orders' and TABLE_SCHEMA = 'test_db' |
|        7 | 0.05994800 | ALTER TABLE orders ENGINE = InnoDB                                                                                                                 |
|        8 | 0.00118250 | select TABLE_NAME,ENGINE,ROW_FORMAT,TABLE_ROWS,DATA_LENGTH FROM information_schema.TABLES WHERE table_name = 'orders' and TABLE_SCHEMA = 'test_db' |
+----------+------------+----------------------------------------------------------------------------------------------------------------------------------------------------+
8 rows in set, 1 warning (0.00 sec)
```
**4.** _Измените my.cnf согласно ТЗ (движок InnoDB) и приведите в ответе измененный файл my.cnf:_  
```commandline
[root@node01 stack]# cat /etc/my.cnf
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
innodb_flush_log_at_trx_commit = 0
innodb_file_format = Barracuda
innodb_log_buffer_size = 1M
key_buffer_size = 640М
max_binlog_size	= 100M
```