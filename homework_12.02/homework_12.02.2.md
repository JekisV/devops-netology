 _Нужно продемонстрировать, что новый пользователь:_
* _может просматривать логи подов и их конфигурацию в `namespace app-namespace`_;
* _ничего другого делать не может_.  

В ходе доработки пришлось заново все поднимать и настраивать, название 
немспейса изменилось на `test-space`, а пользователь стал просто **user**,
как видно из вывода консоли, можем просматривать список подов, и больше
ничего:  
```commandline
user@node-01:~/.kube$ kubectl get pods --namespace=test-space
NAME         READY   STATUS    RESTARTS   AGE
deployment   0/1     Pending   0          5m11s
user@node-01:~/.kube$ kubectl get pods
Error from server (Forbidden): pods is forbidden: User "system:serviceaccount:test-space:user" cannot list resource "pods" in API group "" in the namespace "default"
user@node-01:~/.kube$ kubectl get deployments --namespace=test-space
Error from server (Forbidden): deployments.apps is forbidden: User "system:serviceaccount:test-space:user" cannot list resource "deployments" in API group "apps" in the namespace "test-space"
user@node-01:~/.kube$ kubectl get deployments
Error from server (Forbidden): deployments.apps is forbidden: User "system:serviceaccount:test-space:user" cannot list resource "deployments" in API group "apps" in the namespace "default"
```
_Приложите Role и RoleBinding для этого пользователя. Или покажите как 
иным способом предоставили доступ этому пользователю._  

Во вложении два файла:  
user-role.yml  
role-bin.yml  
