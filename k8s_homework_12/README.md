# Домашнее задание к занятию «Troubleshooting» - Курапов Антон

## Задание. При деплое приложение web-consumer не может подключиться к auth-db. Необходимо это исправить

* Установить приложение по команде:
```shell
kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
```
* Выявить проблему и описать.
* Исправить проблему, описать, что сделано.
* Продемонстрировать, что проблема решена.

## Решение.

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_15/jpg/01_0.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_15/jpg/01_1.PNG)

* web-consumer ищет auth-db по имени auth-db, но auth-db находится в namespace: data, а не web. Внутри Kubernetes сервисы разных неймспейсов нельзя найти просто по имени, нужен полный DNS-адрес.

* исправляем внутри деплоймента строку: 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_15/jpg/01_2.PNG)

* проверяем логи и доступность nginx в браузере 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_15/jpg/01_3.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_15/jpg/01_4.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_15/jpg/01_5.PNG)
