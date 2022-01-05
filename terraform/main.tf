# Provider
provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id                 = "b1g0inpcd7aln4257nul"
  folder_id                = "b1gns3a84pvt7rd1h1vn"
}
# Network
resource "yandex_vpc_network" "default" {
  name = "net"
}

resource "yandex_vpc_subnet" "default" {
  name           = "subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["192.168.101.0/24"]
}

resource "yandex_compute_instance" "node01" {
  name                      = "node01"
  zone                      = "ru-central1-a"
  hostname                  = "node01.netology.cloud"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8f30hur3255mjfi3hq"
      name     = "root-node01"
      type     = "network-nvme"
      size     = "20"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }

  metadata = {
    ssh-keys = "root:${file("~/.ssh/id_rsa.pub")}"
  }
}
