# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 2» - Курапов Антон

## Задание 1. Создать Deployment приложений backend и frontend
* Создать Deployment приложения frontend из образа nginx с количеством реплик 3 шт.
* Создать Deployment приложения backend из образа multitool.
* Добавить Service, которые обеспечат доступ к обоим приложениям внутри кластера.
* Продемонстрировать, что приложения видят друг друга с помощью Service.
* Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.
## Задание 2. Создать Ingress и обеспечить доступ к приложениям снаружи кластера
* Включить Ingress-controller в MicroK8S.
* Создать Ingress, обеспечивающий доступ снаружи по IP-адресу кластера MicroK8S так, чтобы при запросе только по адресу открывался frontend а при добавлении /api - backend.
* Продемонстрировать доступ с помощью браузера или curl с локального компьютера.
* Предоставить манифесты и скриншоты или вывод команды п.2.
## Решение 1.

Deployment приложения frontend с образом nginx и 3 шт реплик. front.yaml: 

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx
  name: frontend
  namespace: default
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
```

Deployment приложения backend с образом multitool back.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: multitool
  template:
    metadata:
      labels:
        app: multitool
    spec:
      containers:
      - name: multitool
        image: wbitt/network-multitool:latest
        ports:
        - containerPort: 80
        env:
        - name: HTTP_PORT
          value: "80"
```

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_5/jpg/01_0.PNG)

 Service для доступа к обоим приложениям:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend-svc
  namespace: default
spec:
  selector:
    app: nginx
  ports:
  - name: for-nginx
    port: 80
```
```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-svc
  namespace: default
spec:
  selector:
    app: multitool
  ports:
  - name: for-multitool
    port: 80
```
![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_5/jpg/01_1.PNG)

проверяем доступность через сервисы: 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_5/jpg/01_2.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_5/jpg/01_2_1.PNG)


## Решение 2.

На мастере активируем ingress

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_5/jpg/01_3.PNG)

создаем ingress.yaml : 

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: test.ru
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-svc
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: backend-svc
            port:
              number: 80
```

проверяем доступность в браузере: 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_5/jpg/01_4.PNG)


