variable "name_prefix" {
  description = "Уникальный префикс для имён ресурсов"
  type        = string
}

variable "vm_names" {
  type    = list
  default = ["vm-1"]
}

# ID образа загрузочного диска
variable "boot_disk" {
  description = "ID of boot disk"
  type        = string
  default     = "fd806u1okplml22f4pmo"
}

# ID подсети
variable "network_interface" {
  description = "ID of network interface"
  type        = string
  default     = "e9b17c6fjq9vaoq182t9"
}

variable "vm_size" {
  description = "Configuration {cores, memory}"
  type = object({
    cores  = number
    memory = number
  })

  default = {
    cores  = 2
    memory = 2
  }

  # ограничения относительно комбинаций количества ядер и объема оперативной памяти связано с фиксированными пресетами ВМ в Yandex Cloud
  validation {
    condition = contains([
      { cores = 2, memory = 2 },
      { cores = 2, memory = 4 },
      { cores = 4, memory = 4 },
      { cores = 4, memory = 8 },
    ], { cores = var.vm_size.cores, memory = var.vm_size.memory })
    error_message = "Acceptable options: 2×2, 2×4, 4×4, 4×8."
  }
}