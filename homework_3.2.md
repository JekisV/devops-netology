1. Команда, которая позволяет менять директорию **C**hange **D**ir - **cd**.  
2. >vagrant@vagrant:~$ touch some  
vagrant@vagrant:~$ echo qwerty >> some 
vagrant@vagrant:~$ grep qwerty some | wc -l  
1  
vagrant@vagrant:~$ grep qwerty some -c  
1
3. >vagrant@vagrant:~$ pstree -p  
systemd(1)─┬─VBoxService(791)─┬─{VBoxService}(793)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├─{VBoxService}(794)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├─{VBoxService}(795)  
   .........
4. >vagrant@vagrant:~$ ls -la /home/vagrant 2>/dev/pts/1
5. >vagrant@vagrant:~$ cat < some > some_1  
vagrant@vagrant:~$ cat some  
drtyui  
1234567  
qwerty  
vagrant@vagrant:~$ cat some_1   
drtyui  
1234567  
qwerty
6. Вывести полуится при использовании перенаправлении вывода но наблюдать в графическом режиме не получиться, нужно переключиться в контекст. 
7. **bash 5>&1** - Создаст дескриптор с 5 и перенатправит его в stdout.  
**echo netology > /proc/$$/fd/5** - выведет в дескриптор 5, который был пернеаправлен в stdout.
8. >vagrant@vagrant:~$ ls -la /root 9>&2 2>&1 1>&9 | grep denied -c
9. Будут выведены переменные окружения.  
Можно получить тоже самое (только с разделением по переменным по строкам):  
printenv  
env
10. **/proc/PID/cmdline** - полный путь до исполняемого файла процесса [PID]  
**/proc/PID/exe** - содержит ссылку до файла запущенного для процесса [PID]
11. >vagrant@vagrant:~$ grep sse /proc/cpuinfo  
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl x
topology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid sse4_1 **sse4_2** x2apic movbe popcnt aes xsave avx rdrand hypervisor lahf_lm abm invpcid_single pti
 fsgsbase avx2 invpcid md_clear flush_l1d  
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl x
topology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid sse4_1 **sse4_2** x2apic movbe popcnt aes xsave avx rdrand hypervisor lahf_lm abm invpcid_single pti
 fsgsbase avx2 invpcid md_clear flush_l1d
12. при подключении ожидается пользователь, а не другой процесс, и нет локального tty в данный момент. 
для запуска можно добавить -t - , и команда исполняется c принудительным созданием псевдотерминала.
13. 
- запускаем процесс top;
- Используйте Ctrl-Z для приостановки процесса;
- Возобновляем процесс в фоновом режиме с помощью bg;
- Ищем идентификатор процесса фонового процесса с jobs -l;
- Отключаем процесс от текущего родителя (оболочки) с помощью **disown PID**;
- запускаем screen;
- командой **reptyr PID** запускаем процесс в скрине.
14. команда tee делает вывод одновременно и в файл, указанный в качестве параметра, и в stdout, 
в данном примере команда получает вывод из stdin, перенаправленный через pipe от stdout команды echo
и так как команда запущена от sudo, соответственно имеет права на запись в файл.
