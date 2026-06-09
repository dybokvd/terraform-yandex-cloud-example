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
}

# Зона доступности, где по умолчанию будут создаваться все ресурсы
provider "yandex" {
  zone = "ru-central1-a"
}

# Тип блока, тип ресурса, имя блока
resource "yandex_compute_instance" "vm-1" {
  name = "test-vm-terraform"
  resources {
    cores  = 2
    memory = 2
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "fd806u1okplml22f4pmo"
    }
  }

  network_interface {
    subnet_id = "e9b17c6fjq9vaoq182t9"
    # Включаем присвоение публичного IP-адреса
    nat = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
    
  allow_stopping_for_update = true
} 
