# Домашнее задание к занятию «Установка Kubernetes» - Курапов Антон

## Задание 1. Установить кластер k8s с 1 master node
* Подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды.
* В качестве CRI — containerd.
* Запуск etcd производить на мастере.
* Способ установки выбрать самостоятельно.
## Решение.
Выбрал способ установки через kubespray


![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_12/jpg/01_0.PNG)

Выполнял по скриптам из презентации и демонстрации лектора. 

в inventary.ini ошибся и указал два раза одну ноду поэтому в кластере вместо 5 нод , получилось 4 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_15/jpg/01_0_1.PNG)

установка прошла успешно : 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_15/jpg/01_1.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_15/jpg/01_2.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/k8s_homework_15/jpg/01_3.PNG)
