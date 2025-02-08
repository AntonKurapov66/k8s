# Домашнее задание к занятию «Kubernetes. Причины появления. Команда kubectl» - Курапов Антон

## Задание 1. Установка MicroK8S
* Установить MicroK8S на локальную машину или на удалённую виртуальную машину.
* Установить dashboard.
* Сгенерировать сертификат для подключения к внешнему ip-адресу.
## Задание 2. Установка и настройка локального kubectl
* Установить на локальную машину kubectl.
* Настроить локально подключение к кластеру.
* Подключиться к дашборду с помощью port-forward.

## Решение 1.

Установил microk8s 

![alt text](https://github.com/AntonKurapov66/k8s/edit/main/k8s_homework_1/jpg/01_0.PNG)

Прокинул порт для дашборда и сгенерировал сертификат, открыл в браузере.

![alt text](https://github.com/AntonKurapov66/k8s/edit/main/k8s_homework_1/jpg/01_2.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/edit/main/k8s_homework_1/jpg/01_3.PNG)
 
![alt text](https://github.com/AntonKurapov66/k8s/edit/main/k8s_homework_1/jpg/01_4.PNG)

## Решение 2.

Установил на вторую ВМ kubectl 

![alt text](https://github.com/AntonKurapov66/k8s/edit/main/k8s_homework_1/jpg/01_5.PNG)

скопировал config с master`а и изменил server в config`е, проверил на второй ВМ ноды в кластере. 

![alt text](https://github.com/AntonKurapov66/k8s/edit/main/k8s_homework_1/jpg/01_6.PNG) 

Так же как и с мастером, пробросил порт для дашборда. 

![alt text](https://github.com/AntonKurapov66/k8s/edit/main/k8s_homework_1/jpg/01_7.PNG)

На вкладке Nodes выден мастер, открывал дашборд через вторую ВМ. 

![alt text](https://github.com/AntonKurapov66/k8s/edit/main/k8s_homework_1/jpg/01_8.PNG)
