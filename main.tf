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