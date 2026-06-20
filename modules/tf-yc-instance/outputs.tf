output "external_ips" {
  description = "external IPs"
  value = {
    for vm_name in var.vm_names :
    vm_name => yandex_compute_instance.vm-1[vm_name].network_interface[0].nat_ip_address
  }
} 