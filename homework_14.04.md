1. Создаем сервис аккаунт:  
```commandline
root@node1:/home/ubuntu# kubectl create serviceaccount netology
serviceaccount/netology created
```
2. Смотрим список сервис-аккаунтов:  
```commandline
root@node1:/home/ubuntu# kubectl get serviceaccounts
NAME       SECRETS   AGE
default    0         18m
netology   0         4m13s
```
3. Получаем информацию в формате YAML и/или JSON:  
```commandline
root@node1:/home/ubuntu# kubectl get serviceaccount netology -o yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: "2022-10-11T19:14:49Z"
  name: netology
  namespace: default
  resourceVersion: "2167"
  uid: eae38b7f-ffdf-4bb6-9c51-66d1cfa5ac2e
root@node1:/home/ubuntu# kubectl get serviceaccount netology -o json
{
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "creationTimestamp": "2022-10-11T19:14:49Z",
        "name": "netology",
        "namespace": "default",
        "resourceVersion": "2167",
        "uid": "eae38b7f-ffdf-4bb6-9c51-66d1cfa5ac2e"
    }
}
```
4. Выгружаем сервис-аккаунты и сохраняем его в файл:  
```commandline
root@node1:/home/ubuntu# kubectl get serviceaccounts -o json > serviceaccounts.json
root@node1:/home/ubuntu# kubectl get serviceaccount netology -o yaml > netology.yml
```
5. Удаляем сервис-аккаунт:  
```commandline
root@node1:/home/ubuntu# kubectl delete serviceaccount netology
serviceaccount "netology" deleted
```
6. Загружаем сервис-аккаунт из файла:  
```commandline
root@node1:/home/ubuntu# kubectl apply -f netology.yml
serviceaccount/netology created
root@node1:/home/ubuntu# kubectl get serviceaccount
NAME       SECRETS   AGE
default    0         24m
netology   0         8s
```
7. Подключение к образу Fedora:  
```commandline
root@node1:/home/ubuntu# kubectl run -ti fedora --image=fedora --restart=Never -- sh
If you don't see a command prompt, try pressing enter.
sh-5.1#
```
8. Считывание и запись значений переменных:  
```commandline
sh-5.1# env | grep KUBE
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_SERVICE_PORT=443
KUBERNETES_PORT_443_TCP=tcp://10.233.0.1:443
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_ADDR=10.233.0.1
KUBERNETES_SERVICE_HOST=10.233.0.1
KUBERNETES_PORT=tcp://10.233.0.1:443
KUBERNETES_PORT_443_TCP_PORT=443
```
Запись в переменные:  
```commandline
sh-5.1# SADIR=/var/run/secrets/kubernetes.io/serviceaccount
sh-5.1# TOKEN=$(cat $SADIR/token)
sh-5.1# CACERT=$SADIR/ca.crt
```
9. Провека подключения к API:  
```commandline
sh-5.1# curl --cacert $CACERT -H "Authorization: Bearer $TOKEN" https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT_HTTPS/api/
{
  "kind": "APIVersions",
  "versions": [
    "v1"
  ],
  "serverAddressByClientCIDRs": [
    {
      "clientCIDR": "0.0.0.0/0",
      "serverAddress": "192.168.101.12:6443"
    }
  ]
}
sh-5.1#
```

Done!!!