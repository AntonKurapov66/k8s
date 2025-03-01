# Домашнее задание к занятию «Хранение в K8s. Часть 1» - Курапов Антон

## Задание 1. Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

* Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
* Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.
* Обеспечить возможность чтения файла контейнером multitool.
* Продемонстрировать, что multitool может читать файл, который периодоически обновляется.
* Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.

## Задание 2. Создать DaemonSet приложения, которое может прочитать логи ноды.

* Создать DaemonSet приложения, состоящего из multitool.
* Обеспечить возможность чтения файла /var/log/syslog кластера MicroK8S.
* Продемонстрировать возможность чтения файла изнутри пода.
* Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.

## Решение 1.

Создадим новый namespace: 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_6/jpg/01_0.PNG)

Создаем Deployment: 

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: homework-multitool-busybox
  namespace: homework6
spec:
  replicas: 1
  selector:
    matchLabels:
      app: main
  template:
    metadata:
      labels:
        app: main
    spec:
      containers:
      - name: busybox
        image: busybox
        command: ['/bin/sh', '-c', 'while true; do echo "Container up $(uptime)" >> /busybox_dir/uptime.log; sleep 10; done']
        volumeMounts:
          - mountPath: "/busybox_dir"
            name: deployment-volume
      - name: multitool
        image: wbitt/network-multitool
        volumeMounts:
          - name: deployment-volume
            mountPath: "/multitool_dir"
      volumes:
        - name: deployment-volume
          emptyDir: {}
```

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_6/jpg/01_1.PNG) 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_6/jpg/01_2.PNG)

## Решение 2.

Создадим DaemonSet:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: multitool-logs
  namespace: homework6
spec:
  selector:
    matchLabels:
      app: mt-logs
  template:
    metadata:
      labels:
        app: mt-logs
    spec:
      containers:
      - name: multitool
        image: wbitt/network-multitool
        volumeMounts:
          - name: log-volume
            mountPath: "/log_data"
      volumes:
        - name: log-volume
          hostPath:
            path: /var/log
```
![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_6/jpg/01_3.PNG)

проверяем : 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_6/jpg/01_4.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_6/jpg/01_5.PNG)


