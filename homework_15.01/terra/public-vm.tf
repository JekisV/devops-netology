resource "yandex_compute_instance" "public-vm" {
  name                      = "public-vm"
  platform_id               = "standard-v3"
  zone                      = "ru-central1-a"
  hostname                  = "public-vm"
  allow_stopping_for_update = true

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ic7gsa68ka13650ld"
      name     = "root-node01"
      type     = "network-hdd"
      size     = "25"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    user-data = "${file("./user.txt")}"
  }
}
