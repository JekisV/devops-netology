_Вывод команды `terraform workspace list`_  
```commandline
[jekis_@fedora 07-terraform-03-basic]$ terraform workspace list
  default
* prod
  stage
```

_Вывод команды `terraform plan` для воркспейса `prod`:_  
```commandline
[jekis_@fedora 07-terraform-03-basic]$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # module.news.data.yandex_compute_image.image will be read during apply
  # (config refers to values not yet known)
 <= data "yandex_compute_image" "image"  {
      + created_at    = (known after apply)
      + description   = (known after apply)
      + family        = "centos-8"
      + folder_id     = (known after apply)
      + id            = (known after apply)
      + image_id      = (known after apply)
      + labels        = (known after apply)
      + min_disk_size = (known after apply)
      + name          = (known after apply)
      + os_type       = (known after apply)
      + product_ids   = (known after apply)
      + size          = (known after apply)
      + status        = (known after apply)
    }

  # module.news.yandex_compute_instance.instance[0] will be created
  + resource "yandex_compute_instance" "instance" {
      + created_at                = (known after apply)
      + description               = "News App Demo"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "news-1"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDGmyMHgig4Jzlh8si4fxKGrwIy4q00dNh3H9/BhP3PEFDXYvabf8E6AZ05ktacCXVWFIB4bz3JTMiwVwmlVcE1xMRJARyBmDEKNjUZDGFDU1C31yjxKsqpg3b0MuMSOPrnH/4Wj2pizmxsEGuETnsQ/X01QCVt1Gk0DV4PyJ2Z0tOCcxu0D+Iobz+9zXEXtEm1s3yO+f9ejylddrXQyLTp9vmyk02WqbMCsd4/FgqURgA9Iv2LwY5oHdhsC1t3CvnEZBKEwHdS78IK7Y7oKFFDw7m3CY73d4hgyQK1I09oX6zct+RU63atu56hOBbFosZHY2R+BKgVx/r0puV8wn4O4/CJRMWI+bGsAf3ZyYcrVdeGI0buC45CmQmmJ54gJc8dtr414KKCisTZrwkwM+istt09/VWn9VVbT+1j5SUvN/0wgAvvUh9/aqYqEnYYGArB7JXtpq3hai723sfsGMU3ZgV3DQEspVV/uoH6CKXL0a1i+mRJNkgQXGxxVUC4rx0= jekis_@fedora
            EOT
        }
      + name                      = "news-1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + description = (known after apply)
              + image_id    = (known after apply)
              + name        = (known after apply)
              + size        = 40
              + snapshot_id = (known after apply)
              + type        = "network-ssd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + placement_group_id = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # module.news.yandex_compute_instance.instance[1] will be created
  + resource "yandex_compute_instance" "instance" {
      + created_at                = (known after apply)
      + description               = "News App Demo"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "news-2"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDGmyMHgig4Jzlh8si4fxKGrwIy4q00dNh3H9/BhP3PEFDXYvabf8E6AZ05ktacCXVWFIB4bz3JTMiwVwmlVcE1xMRJARyBmDEKNjUZDGFDU1C31yjxKsqpg3b0MuMSOPrnH/4Wj2pizmxsEGuETnsQ/X01QCVt1Gk0DV4PyJ2Z0tOCcxu0D+Iobz+9zXEXtEm1s3yO+f9ejylddrXQyLTp9vmyk02WqbMCsd4/FgqURgA9Iv2LwY5oHdhsC1t3CvnEZBKEwHdS78IK7Y7oKFFDw7m3CY73d4hgyQK1I09oX6zct+RU63atu56hOBbFosZHY2R+BKgVx/r0puV8wn4O4/CJRMWI+bGsAf3ZyYcrVdeGI0buC45CmQmmJ54gJc8dtr414KKCisTZrwkwM+istt09/VWn9VVbT+1j5SUvN/0wgAvvUh9/aqYqEnYYGArB7JXtpq3hai723sfsGMU3ZgV3DQEspVV/uoH6CKXL0a1i+mRJNkgQXGxxVUC4rx0= jekis_@fedora
            EOT
        }
      + name                      = "news-2"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + description = (known after apply)
              + image_id    = (known after apply)
              + name        = (known after apply)
              + size        = 40
              + snapshot_id = (known after apply)
              + type        = "network-ssd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + placement_group_id = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # module.vpc.yandex_resourcemanager_folder.folder[0] will be created
  + resource "yandex_resourcemanager_folder" "folder" {
      + cloud_id    = (known after apply)
      + created_at  = (known after apply)
      + description = "terraform managed"
      + id          = (known after apply)
      + name        = "prod"
    }

  # module.vpc.yandex_vpc_network.this will be created
  + resource "yandex_vpc_network" "this" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + description               = "managed by terraform prod network"
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + name                      = "prod"
      + subnet_ids                = (known after apply)
    }

  # module.vpc.yandex_vpc_subnet.this["ru-central1-a"] will be created
  + resource "yandex_vpc_subnet" "this" {
      + created_at     = (known after apply)
      + description    = "managed by terraform prod subnet for zone ru-central1-a"
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + name           = "prod-ru-central1-a"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.128.0.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 5 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```