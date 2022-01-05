output "internal_ip_address_node01_yandex_cloud" {
  value = yandex_compute_instance.node01.network_interface.0.ip_address
}

output "external_ip_address_node01_yandex_cloud" {
  value = yandex_compute_instance.node01.network_interface.0.nat_ip_address
}

output "zone" {
  value = yandex_compute_instance.node01.zone
}

output "network_id" {
  value = yandex_compute_instance.node01.network_interface.0.subnet_id
}
