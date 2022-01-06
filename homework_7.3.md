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

Terraform will perform the following actions:

  # yandex_compute_instance_group.prod will be created
  + resource "yandex_compute_instance_group" "prod" {
      + created_at          = (known after apply)
      + deletion_protection = false
      + folder_id           = "b1gns3a84pvt7rd1h1vn"
      + id                  = (known after apply)
      + instances           = (known after apply)
      + name                = "prod-group"
      + service_account_id  = "b1g0inpcd7aln4257nul"
      + status              = (known after apply)

      + allocation_policy {
          + zones = [
              + "ru-central1-a",
            ]
        }

      + deploy_policy {
          + max_creating     = 0
          + max_deleting     = 0
          + max_expansion    = 0
          + max_unavailable  = 1
          + startup_duration = 0
          + strategy         = (known after apply)
        }

      + instance_template {
          + labels      = (known after apply)
          + metadata    = {
              + "ssh-keys" = <<-EOT
                    jekis_:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDGmyMHgig4Jzlh8si4fxKGrwIy4q00dNh3H9/BhP3PEFDXYvabf8E6AZ05ktacCXVWFIB4bz3JTMiwVwmlVcE1xMRJARyBmDEKNjUZDGFDU1C31yjxKsqpg3b0MuMSOPrnH/4Wj2pizmxsEGuETnsQ/X01QCVt1Gk0DV4PyJ2Z0tOCcxu0D+Iobz+9zXEXtEm1s3yO+f9ejylddrXQyLTp9vmyk02WqbMCsd4/FgqURgA9Iv2LwY5oHdhsC1t3CvnEZBKEwHdS78IK7Y7oKFFDw7m3CY73d4hgyQK1I09oX6zct+RU63atu56hOBbFosZHY2R+BKgVx/r0puV8wn4O4/CJRMWI+bGsAf3ZyYcrVdeGI0buC45CmQmmJ54gJc8dtr414KKCisTZrwkwM+istt09/VWn9VVbT+1j5SUvN/0wgAvvUh9/aqYqEnYYGArB7JXtpq3hai723sfsGMU3ZgV3DQEspVV/uoH6CKXL0a1i+mRJNkgQXGxxVUC4rx0= jekis_@fedora
                EOT
            }
          + platform_id = "standard-v1"

          + boot_disk {
              + device_name = (known after apply)
              + mode        = "READ_WRITE"

              + initialize_params {
                  + image_id    = "fd8ao0399nc5991u50j5"
                  + size        = (known after apply)
                  + snapshot_id = (known after apply)
                  + type        = "network-hdd"
                }
            }

          + network_interface {
              + ip_address   = (known after apply)
              + ipv4         = true
              + ipv6         = (known after apply)
              + ipv6_address = (known after apply)
              + nat          = (known after apply)
              + network_id   = (known after apply)
              + subnet_ids   = (known after apply)
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

      + scale_policy {

          + fixed_scale {
              + size = 2
            }
        }
    }

  # yandex_vpc_network.default will be created
  + resource "yandex_vpc_network" "default" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "net"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.default will be created
  + resource "yandex_vpc_subnet" "default" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.101.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 4 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```