# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 1» - Курапов Антон

## Задание 1. Создать Deployment и обеспечить доступ к контейнерам приложения по разным портам из другого Pod внутри кластера
* Создать Deployment приложения, состоящего из двух контейнеров (nginx и multitool), с количеством реплик 3 шт.
* Создать Service, который обеспечит доступ внутри кластера до контейнеров приложения из п.1 по порту 9001 — nginx 80, по 9002 — multitool 8080.
* Создать отдельный Pod с приложением multitool и убедиться с помощью curl, что из пода есть доступ до приложения из п.1 по разным портам в разные контейнеры.
* Продемонстрировать доступ с помощью curl по доменному имени сервиса.
* Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.
## Задание 2. Создать Service и обеспечить доступ к приложениям снаружи кластера
* Создать отдельный Service приложения из Задания 1 с возможностью доступа снаружи кластера к nginx, используя тип NodePort.
* Продемонстрировать доступ с помощью браузера или curl с локального компьютера.
* Предоставить манифест и Service в решении, а также скриншоты или вывод команды п.2.

## Решение 1.

Создал deployment и сервис: 

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: dep-multitool
  name: dep-multitool
  namespace: default
spec:
  replicas: 3
  selector:
    matchLabels:
      app: multitool
  template:
    metadata:
      labels:
        app: multitool
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
      - name: multitool
        image: wbitt/network-multitool:latest
        ports:
        - containerPort: 8080
        env:
        - name: HTTP_PORT
          value: "8080"
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: deployment-svc4
spec:
  selector:
    app: multitool
  ports:
  - name: for-nginx
    port: 9001
    targetPort: 80
  - name: for-multitool
    port: 9002
    targetPort: 8080
```

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_4/jpg/01_1.PNG)

Создадаим отдельный под для multitool: 

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: multitool-pod4
  name: multitool-pod4
  namespace: default
spec:
  containers:
  - name: multitool
    image: wbitt/network-multitool
    ports:
    - containerPort: 8090
      name: multitool-port
``` 
![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_4/jpg/01_2.PNG)

Теперь изнутрки пода через curl проверим подключение:

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_4/jpg/01_3_0.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_4/jpg/01_3_1.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_4/jpg/01_3_2.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_4/jpg/01_3_3.PNG)

Теперь изнутрки пода через curl проверим подключение по доменному имени:

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_4/jpg/01_4.PNG)


## Решение 2.

Создадим сервис svc-multitool-nodeport.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: svc-multitool-nodeport
spec:
  selector:
    app: multitool
  ports:
    - name: for-nginx
      nodePort: 30500
      targetPort: 80
      port: 80
    - name: for-multitool
      nodePort: 30501
      targetPort: 8080
      port: 8080
  type: NodePort
```
![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_4/jpg/01_5.PNG)

проверяем доступность в браузере 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_4/jpg/01_6.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_4/jpg/01_7.PNG)
