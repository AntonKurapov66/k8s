# Домашнее задание к занятию «Вычислительные мощности. Балансировщики нагрузки» - Курапов Антон

## Задание 1. Yandex Cloud

**Что нужно сделать**

1. Создать бакет Object Storage и разместить в нём файл с картинкой:

 - Создать бакет в Object Storage с произвольным именем (например, _имя_студента_дата_).
 - Положить в бакет файл с картинкой.
 - Сделать файл доступным из интернета.
 
2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:

 - Создать Instance Group с тремя ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`.
 - Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata).
 - Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из бакета.
 - Настроить проверку состояния ВМ.
 
3. Подключить группу к сетевому балансировщику:

 - Создать сетевой балансировщик.
 - Проверить работоспособность, удалив одну или несколько ВМ.

## Решение 1.
 
* Демонстрация конечного результата: 

 - Выполненный код terraforma: 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/cloudhomework_2/jpg/01_0.PNG)

 - проверка в облаке и браузере 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/cloudhomework_2/jpg/01_1_0.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/cloudhomework_2/jpg/01_1.PNG)

 - проверка на балансирах 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/cloudhomework_2/jpg/01_3.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/cloudhomework_2/jpg/01_2.PNG)

 - удаление двух ВМ и проверка в браузере 

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/cloudhomework_2/jpg/01_4.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/cloudhomework_2/jpg/01_4_1.PNG)


код terraform лежит в : 

https://github.com/AntonKurapov66/k8s/blob/main/cloudhomework_2/terraform