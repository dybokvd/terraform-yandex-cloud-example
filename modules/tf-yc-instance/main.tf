
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
    disk_id = yandex_compute_disk.disk-1[each.key].id
    auto_delete = false
  }
}

resource "yandex_compute_disk" "disk-1" {
  for_each = toset(var.vm_names)
  name = "terraform-test-disk-${var.name_prefix}-${each.key}"
  type = "network-hdd"
  zone = "ru-central1-a"
  size = 3
  description = "Супер важные данные"
}
