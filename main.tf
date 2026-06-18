terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      # Версия провайдера, с которой будет работать конфигурация
      version = ">= 0.87.0"
    }
  }
  # Версия CLI Terraform
  required_version = ">= 0.13"

  backend "s3" {
    endpoint = "https://storage.yandexcloud.net"
    bucket = "s16128071-terraform"
    region = "ru-central1"
    key = "state/terraform.tfstate"

    skip_region_validation = true
    skip_credentials_validation = true
    skip_requesting_account_id = true
    skip_s3_checksum = true 
  }
}

# Зона доступности, где по умолчанию будут создаваться все ресурсы
provider "yandex" {
  zone = "ru-central1-a"
}

# Тип блока, тип ресурса, имя блока
resource "yandex_compute_instance" "vm-1" {
  for_each = toset(var.vm_names)
  name = "terraform-test-${var.name_prefix}-${each.key}"

  resources {
    cores  = var.vm_size.cores
    memory = var.vm_size.memory
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = var.boot_disk
    }
  }

  network_interface {
    subnet_id = var.network_interface
    # Включаем присвоение публичного IP-адреса
    nat = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
    
  allow_stopping_for_update = true

  secondary_disk {
    disk_id = yandex_compute_disk.disk-1.id
    auto_delete = false
  }
}

resource "yandex_compute_disk" "disk-1" {
  name = "test-disk-terraform"
  type = "network-hdd"
  zone = "ru-central1-a"
  size = 3
  description = "Супер важные данные"
}
