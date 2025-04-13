output "bucket_name" {
  value = yandex_storage_bucket.bucket.bucket
}

output "image_url" {
  value = "https://storage.yandexcloud.net/${yandex_storage_bucket.bucket.bucket}/test.jpg"
}

output "access_key" {
  value     = yandex_iam_service_account_static_access_key.sa_key.access_key
  sensitive = true
}

output "secret_key" {
  value     = yandex_iam_service_account_static_access_key.sa_key.secret_key
  sensitive = true
}

output "balancer_ip" {
  value = yandex_lb_network_load_balancer.nlb.listener.*.external_address_spec[0].*.address
}
