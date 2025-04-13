# Домашнее задание к занятию «Безопасность в облачных провайдерах» - Курапов Антон

## Задание 1. Yandex Cloud

**Что нужно сделать**

1. С помощью ключа в KMS необходимо зашифровать содержимое бакета:

 - создать ключ в KMS;
 - с помощью ключа зашифровать содержимое бакета, созданного ранее.

## Решение 1.
 
* Демонстрация конечного результата: 

Добавил ресурс  yandex_kms_symmetric_key и добавил его в конфигурацию бакета: 

```hcl
# Создание ключа в KMS
resource "yandex_kms_symmetric_key" "key-a" {
  name              = "example-symetric-key"
  default_algorithm = "AES_256"
  rotation_period   = "8760h" // equal to 1 year
}


# Бакет
resource "yandex_storage_bucket" "bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa_key.secret_key
  bucket     = "lamp-bucket-${formatdate("YYYYMMDD", timestamp())}"
  acl        = "public-read"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
```


![alt text](https://github.com/AntonKurapov66/k8s/blob/main/cloudhomework_3/jpg/01_0.PNG)

![alt text](https://github.com/AntonKurapov66/k8s/blob/main/cloudhomework_3/jpg/01_1.PNG)


код terraform лежит в : 

https://github.com/AntonKurapov66/k8s/blob/main/cloudhomework_2/terraform