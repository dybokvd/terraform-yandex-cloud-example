output "root_external_ips" {
  description = "Public IPs from child module"
  value       = module.tf-yc-instance.external_ips
}