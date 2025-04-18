# Домашнее задание к занятию «Организация сети» - Курапов Антон

## Задание 1. Yandex Cloud

Что нужно сделать:

1. Создать пустую VPC. Выбрать зону.

2. Публичная подсеть.
* Создать в VPC subnet с названием public, сетью 192.168.10.0/24.
* Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1.
* Создать в этой публичной подсети виртуалку с публичным IP, подключиться к ней и убедиться, что есть доступ к интернету.

3. Приватная подсеть.
* Создать в VPC subnet с названием private, сетью 192.168.20.0/24.
* Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс.
* Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее, и убедиться, что есть доступ к интернету.

## Решение 1.
 
* Демонстрация конечного результата: 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/cloudhomework_1/jpg/01_0.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/cloudhomework_1/jpg/01_1.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/cloudhomework_1/jpg/01_2.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/cloudhomework_1/jpg/01_3.PNG)

* Проверка доступности интернета на ВМ в приватной сети и в публичной сети: 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/cloudhomework_1/jpg/01_4.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/cloudhomework_1/jpg/01_5.PNG)