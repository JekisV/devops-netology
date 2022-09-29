Запустить модуль Vault конфигураций через утилиту kubectl  
```commandline
root@node1:/home/ubuntu# kubectl apply -f vault-pod.yml 
pod/14.2-netology-vault created
root@node1:/home/ubuntu# kubectl get pods
NAME                     READY   STATUS    RESTARTS   AGE
14.2-netology-vault      1/1     Running   0          13s
```
Получить значение внутреннего IP пода  
```commandline
root@node1:/home/ubuntu# kubectl get pod 14.2-netology-vault -o json | jq -c '.status.podIPs'
[{"ip":"10.233.75.3"}]
```
Запустить второй модуль для использования в качестве клиента  
<details>
<summary> kubectl run -i --tty fedora --image=fedora --restart=Never -- sh </summary>

```commandline
root@node1:/home/ubuntu# kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
If you don't see a command prompt, try pressing enter.
sh-5.1# dnf -y install pip
Fedora 36 - x86_64                                                                                                                      7.0 MB/s |  81 MB     00:11    
Fedora 36 openh264 (From Cisco) - x86_64                                                                                                2.6 kB/s | 2.5 kB     00:00    
Fedora Modular 36 - x86_64                                                                                                              4.9 MB/s | 2.4 MB     00:00    
Fedora 36 - x86_64 - Updates                                                                                                            6.9 MB/s |  28 MB     00:04    
Fedora Modular 36 - x86_64 - Updates                                                                                                    4.3 MB/s | 2.8 MB     00:00    
Dependencies resolved.
========================================================================================================================================================================
 Package                                        Architecture                       Version                                    Repository                           Size
========================================================================================================================================================================
Installing:
 python3-pip                                    noarch                             21.3.1-3.fc36                              updates                             1.8 M
Upgrading:
 python3                                        x86_64                             3.10.7-1.fc36                              updates                              28 k
 python3-libs                                   x86_64                             3.10.7-1.fc36                              updates                             7.4 M
Installing weak dependencies:
 libxcrypt-compat                               x86_64                             4.4.28-1.fc36                              fedora                               90 k
 python3-setuptools                             noarch                             59.6.0-2.fc36                              fedora                              936 k

Transaction Summary
========================================================================================================================================================================
Install  3 Packages
Upgrade  2 Packages

Total download size: 10 M
Downloading Packages:
(1/5): libxcrypt-compat-4.4.28-1.fc36.x86_64.rpm                                                                                        2.6 MB/s |  90 kB     00:00    
(2/5): python3-3.10.7-1.fc36.x86_64.rpm                                                                                                 1.1 MB/s |  28 kB     00:00    
(3/5): python3-pip-21.3.1-3.fc36.noarch.rpm                                                                                              18 MB/s | 1.8 MB     00:00    
(4/5): python3-setuptools-59.6.0-2.fc36.noarch.rpm                                                                                      7.1 MB/s | 936 kB     00:00    
(5/5): python3-libs-3.10.7-1.fc36.x86_64.rpm                                                                                            7.3 MB/s | 7.4 MB     00:01    
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                   5.9 MB/s |  10 MB     00:01     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                1/1 
  Upgrading        : python3-libs-3.10.7-1.fc36.x86_64                                                                                                              1/7 
  Upgrading        : python3-3.10.7-1.fc36.x86_64                                                                                                                   2/7 
  Installing       : python3-setuptools-59.6.0-2.fc36.noarch                                                                                                        3/7 
  Installing       : libxcrypt-compat-4.4.28-1.fc36.x86_64                                                                                                          4/7 
  Installing       : python3-pip-21.3.1-3.fc36.noarch                                                                                                               5/7 
  Cleanup          : python3-3.10.4-1.fc36.x86_64                                                                                                                   6/7 
  Cleanup          : python3-libs-3.10.4-1.fc36.x86_64                                                                                                              7/7 
  Running scriptlet: python3-libs-3.10.4-1.fc36.x86_64                                                                                                              7/7 
  Verifying        : libxcrypt-compat-4.4.28-1.fc36.x86_64                                                                                                          1/7 
  Verifying        : python3-setuptools-59.6.0-2.fc36.noarch                                                                                                        2/7 
  Verifying        : python3-pip-21.3.1-3.fc36.noarch                                                                                                               3/7 
  Verifying        : python3-3.10.7-1.fc36.x86_64                                                                                                                   4/7 
  Verifying        : python3-3.10.4-1.fc36.x86_64                                                                                                                   5/7 
  Verifying        : python3-libs-3.10.7-1.fc36.x86_64                                                                                                              6/7 
  Verifying        : python3-libs-3.10.4-1.fc36.x86_64                                                                                                              7/7 

Upgraded:
  python3-3.10.7-1.fc36.x86_64                                                     python3-libs-3.10.7-1.fc36.x86_64                                                    
Installed:
  libxcrypt-compat-4.4.28-1.fc36.x86_64                   python3-pip-21.3.1-3.fc36.noarch                   python3-setuptools-59.6.0-2.fc36.noarch                  

Complete!
sh-5.1# pip install hvac
Collecting hvac
  Downloading hvac-1.0.2-py3-none-any.whl (143 kB)
     |████████████████████████████████| 143 kB 1.1 MB/s            
Collecting requests<3.0.0,>=2.27.1
  Downloading requests-2.28.1-py3-none-any.whl (62 kB)
     |████████████████████████████████| 62 kB 1.1 MB/s            
Collecting pyhcl<0.5.0,>=0.4.4
  Downloading pyhcl-0.4.4.tar.gz (61 kB)
     |████████████████████████████████| 61 kB 3.3 MB/s            
  Installing build dependencies ... done
  Getting requirements to build wheel ... done
  Preparing metadata (pyproject.toml) ... done
Collecting charset-normalizer<3,>=2
  Downloading charset_normalizer-2.1.1-py3-none-any.whl (39 kB)
Collecting idna<4,>=2.5
  Downloading idna-3.4-py3-none-any.whl (61 kB)
     |████████████████████████████████| 61 kB 59 kB/s             
Collecting urllib3<1.27,>=1.21.1
  Downloading urllib3-1.26.12-py2.py3-none-any.whl (140 kB)
     |████████████████████████████████| 140 kB 4.8 MB/s            
Collecting certifi>=2017.4.17
  Downloading certifi-2022.9.24-py3-none-any.whl (161 kB)
     |████████████████████████████████| 161 kB 6.1 MB/s            
Building wheels for collected packages: pyhcl
  Building wheel for pyhcl (pyproject.toml) ... done
  Created wheel for pyhcl: filename=pyhcl-0.4.4-py3-none-any.whl size=50147 sha256=85471d625e4bb4963cd37d2bd4041df28707aa655ada65f16c625b78f262e3d9
  Stored in directory: /root/.cache/pip/wheels/6c/ad/33/e11e917cf04cb1533cab6e7aaa8cee93c950aa82c32398b83e
Successfully built pyhcl
Installing collected packages: urllib3, idna, charset-normalizer, certifi, requests, pyhcl, hvac
Successfully installed certifi-2022.9.24 charset-normalizer-2.1.1 hvac-1.0.2 idna-3.4 pyhcl-0.4.4 requests-2.28.1 urllib3-1.26.12
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
```
</details>

Запустить интепретатор Python и выполнить следующий код, предварительно
поменяв IP и токен

<details>
<summary> Console output </summary>

```commandline
sh-5.1# python3
Python 3.10.7 (main, Sep  7 2022, 00:00:00) [GCC 12.2.1 20220819 (Red Hat 12.2.1-1)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import hvac
>>> client = hvac.Client(
...  url='http://10.233.75.3:8200',
... token='aiphohTaa0eeHei',
... )
>>> client.is_authenticated()
True
>>> client.secrets.kv.v2.create_or_update_secret(
...  path='hvac',
... secret=dict(netology='Big secret!!!'),
... )
{'request_id': 'fbe6fc9c-869b-0df2-ead1-f459a4a06249', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'created_time': '2022-09-29T17:40:29.417979758Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}, 'wrap_info': None, 'warnings': None, 'auth': None}
>>> client.secrets.kv.v2.read_secret_version(
...  path='hvac',
... )
{'request_id': '3e02e380-d0ac-03df-7f64-8905d4d3dd85', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'data': {'netology': 'Big secret!!!'}, 'metadata': {'created_time': '2022-09-29T17:40:29.417979758Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}}, 'wrap_info': None, 'warnings': None, 'auth': None}
```
</details>

---
