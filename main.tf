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

module "tf-yc-instance" {
  source = "./modules/tf-yc-instance"
  name_prefix = "s16128071"
  vm_size = {
    memory = 4
    cores  = 2
  }
  vm_names = ["vm-1", "vm-2", "vm-3"]
}