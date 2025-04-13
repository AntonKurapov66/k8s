# Сервисный аккаунт
resource "yandex_iam_service_account" "sa" {
  name      = "terraform-sa"
  folder_id = var.folder_id
}

# Роли для SA
resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
  depends_on = [yandex_iam_service_account.sa]
}

resource "yandex_resourcemanager_folder_iam_member" "storage_admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
  depends_on = [yandex_iam_service_account.sa]
}

resource "yandex_resourcemanager_folder_iam_member" "compute_admin" {
  folder_id = var.folder_id
  role      = "compute.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
  depends_on = [yandex_iam_service_account.sa]
}

resource "yandex_resourcemanager_folder_iam_member" "loadbalancer_admin" {
  folder_id = var.folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
  depends_on = [yandex_iam_service_account.sa]
}

# Статический ключ для Object Storage
resource "yandex_iam_service_account_static_access_key" "sa_key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "Static key for Terraform-managed SA"
}

# Сеть
resource "yandex_vpc_network" "network" {}

resource "yandex_vpc_subnet" "subnet" {
  zone           = var.default_zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.1.0.0/24"]
  name           = "public-subnet"
}

# Бакет
resource "yandex_storage_bucket" "bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa_key.secret_key
  bucket     = "lamp-bucket-${formatdate("YYYYMMDD", timestamp())}"
  acl        = "public-read"

}

resource "yandex_storage_object" "image" {
  bucket = yandex_storage_bucket.bucket.bucket
  access_key = yandex_iam_service_account_static_access_key.sa_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa_key.secret_key
  key    = "test.jpg"
  source = "/home/cloudoperator/cloudhomework/test.jpg"
  acl    = "public-read"
  content_type = "image/jpeg"
}

# Instance Group
resource "yandex_compute_instance_group" "lamp_group" {
  name               = "lamp-group"
  folder_id          = var.folder_id
  service_account_id = var.existing_sa_id
  deletion_protection = false

  instance_template {
    platform_id = "standard-v1"

    resources {
      cores  = 2
      memory = 2
    }

    boot_disk {
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
      }
    }

    network_interface {
      subnet_ids = [yandex_vpc_subnet.subnet.id]
      nat       = true
    }

    metadata = {
      user-data = <<-EOF
        #!/bin/bash
        echo "<html><body><h1>Hello from LAMP VM</h1><img src='https://storage.yandexcloud.net/${yandex_storage_bucket.bucket.bucket}/${yandex_storage_object.image.key}'></body></html>" > /var/www/html/index.html
        systemctl restart apache2
      EOF
      ssh-keys = "ubuntu:${var.ssh_public_key_path}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 1
  }

  health_check {
    http_options {
      port = 80
      path = "/"
    }
  }
}

# Target Group
resource "yandex_lb_target_group" "target_group" {
  name = "lamp-target-group"

  dynamic "target" {
    for_each = toset([0, 1, 2])  # Для трех ВМ
    content {
      subnet_id = yandex_vpc_subnet.subnet.id
      address   = yandex_compute_instance_group.lamp_group.instances[target.value].network_interface[0].ip_address
    }
  }
}


# Load Balancer
resource "yandex_lb_network_load_balancer" "nlb" {
  name = "lamp-nlb"

  listener {
    name        = "http"
    port        = 80
    target_port = 80
    protocol    = "tcp"
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.target_group.id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}
