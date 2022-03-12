Для загрузки ролей необходимо выполнить команду:  

`ansible-galaxy install -r requirements.yml`
###
Для запуска `playbook` выполнить команду:  

`ansible-playbook -i inventory/prod/hosts.yaml install.yaml`
###
В процессе работы выполнения `playbook` происходит установка ролей:  
**elastic** - установка и настройка Elasticsearch;  
**kibana** - установка и настройка Kibana;  
**filebeat** - установка и настройка Filebeat.