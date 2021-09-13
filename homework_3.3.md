1. в моем случае вывод следующий:  
`chdir("/tmp")`
2. `openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3`  
3. для начала ищем процесс, который пишет лог, прибиваем его командой `kill -9 PID`, затем посылаем эхо в файл с логом `echo > log_file`.  
4. zombie процессы освобождают свои ресурсы, но не освобождают запись в таблице процессов.  
5. не совсем понял что именно нужно тут отобразить, но за первые две секунды в консоль выпал следующий вывод:  
```commandline
sudo /usr/sbin/opensnoop-bpfcc
PID    COMM               FD ERR PATH
610    irqbalance          6   0 /proc/interrupts
610    irqbalance          6   0 /proc/stat
610    irqbalance          6   0 /proc/irq/20/smp_affinity
610    irqbalance          6   0 /proc/irq/0/smp_affinity
610    irqbalance          6   0 /proc/irq/1/smp_affinity
610    irqbalance          6   0 /proc/irq/8/smp_affinity
610    irqbalance          6   0 /proc/irq/12/smp_affinity
610    irqbalance          6   0 /proc/irq/14/smp_affinity
610    irqbalance          6   0 /proc/irq/15/smp_affinity
853    vminfo              4   0 /var/run/utmp
590    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
590    dbus-daemon        18   0 /usr/share/dbus-1/system-services
590    dbus-daemon        -1   2 /lib/dbus-1/system-services
590    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
853    vminfo              4   0 /var/run/utmp
```
6. системный вызов uname()  
`Part of the utsname information is also accessible  via  /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.`  
7. В `cmd1 && cmd2` `cmd2` выполняется только в том случае, если `cmd1` завершится успешно (возвращает 0). В `cmd1 ; cmd2` `cmd2` выполняется в любом случае. `set -e` останавливает выполнение сценария, если команда или конвейер имеют ошибку. 
>Есть ли смысл использовать в bash `&&`, если применить `set -e`?  

Нет, в этом нет никакого смысла.  
8. Ключ **-e** - прерывает выполнение исполнения при ошибке любой команды кроме последней в последовательности;  
**-x** - вывод трейса простых команд;  
**-u** - неустановленные/не заданные параметры и переменные считаются как ошибки, с выводом в stderr текста ошибки и выполнит завершение не интерактивного вызова;  
**-o** - возвращает код возврата набора/последовательности команд, ненулевой при последней команды или 0 для успешного выполнения команд.  
Данная связка ключей повышает детализацию вывода ошибок и завершения сценария при наличии ошибок, на любом этапе выполнения сценария, кроме последней завершающей команды.  
9. 
```commandline
vagrant@vagrant:~$ ps -o stat
STAT
Ss
R+
```
В моем случае `Ss` - спящий процесс, ожидающий завершения, лидер сеанса, а `R+` - выполняющийся процесс находящийся в группе процессов переднего плана.
