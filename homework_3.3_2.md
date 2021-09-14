1. Тогда решение будет следующим:  
```commandline
...
vim     1287 vagrant    4u   REG  253,0    12288 131094 /home/vagrant/.some.swp (deleted)  
root@vagrant:/home/vagrant# echo > /proc/1287/fd/4  

```