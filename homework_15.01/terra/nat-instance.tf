resource "yandex_compute_instance" "nat-instance" {
  name                      = "nat-instance"
  platform_id               = "standard-v3"
  zone                      = "ru-central1-a"
  hostname                  = "nat-instance"
  allow_stopping_for_update = true

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    ip_address = "192.168.10.254"
    nat        = true
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    user-data = "${file("./user.txt")}"
  }
}
