# Домашнее задание к занятию «Запуск приложений в K8S» - Курапов Антон

## Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod
* Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.
* После запуска увеличить количество реплик работающего приложения до 2.
* Продемонстрировать количество подов до и после масштабирования.
* Создать Service, который обеспечит доступ до реплик приложений из п.1.
* Создать отдельный Pod с приложением multitool и убедиться с помощью curl, что из пода есть доступ до приложений из п.1.

## Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий
* Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.
* Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.
* Создать и запустить Service. Убедиться, что Init запустился.
* Продемонстрировать состояние пода до и после запуска сервиса.

## Решение 1.

Создадим deployment.yaml: 

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: multitool
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
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
      - name: multitool
        image: wbitt/network-multitool:latest
        ports:
        - containerPort: 8080
```
![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_3/jpg/01_0.PNG)

под не может подняться из-за ошибки: 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_3/jpg/01_1.PNG)

добавляю ENV: 
```yaml
 env:
        - name: HTTP_PORT
          value: "7080"
```

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_3/jpg/01_2.PNG)

увеличиваю кол-во реплик изменяю replicas в yaml`ике 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_3/jpg/01_3.PNG)

Создал сервис в deployment-svc.yaml для доступа к репликам приложений: 

```yaml
apiVersion: v1
kind: Service
metadata:
  name: deployment-svc
spec:
  selector:
    app: multitool
  ports:
  - name: for-nginx
    port: 80
    targetPort: 80
  - name: for-multitool
    port: 7080
    targetPort: 7080 
```
![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_3/jpg/01_4.PNG)

Создал под для multitool 

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: multitool
  name: multitool-app
  namespace: default
spec:
  containers:
  - name: multitool
    image: wbitt/network-multitool
    ports:
    - containerPort: 8080
    env:
      - name: HTTP_PORT
        value: "7080"
```
![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_3/jpg/01_5.PNG)

теперь из под отдельного пода будем проверять доступность приложения созданного ранее: 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_3/jpg/01_6_0.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_3/jpg/01_6_1.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_3/jpg/01_6_3.PNG)

## Решение 2.

Создадим deployment-init.yaml:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx-app
  name: nginx-app
  namespace: default
spec:
  replicas: 1
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
      initContainers:
      - name: init-nginx-svc
        image: busybox
        command: ['sh', '-c', 'until nslookup nginx-svc.default.svc.cluster.local; do echo waiting for nginx-svc; sleep 5; done;']
```
убеждаемся что старт подов не произошел: 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_3/jpg/01_7.PNG)

Создадим Service nginx-svc.yaml и убедимся что init запустился

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
spec:
  selector:
    app: nginx
  ports:
  - name: http-port
    port: 80
    protocol: TCP
    targetPort: 80
```
![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_3/jpg/01_8.PNG)
