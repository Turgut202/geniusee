#имя провайдера чем мы хотим управлять, в данном случае vsphere
provider "vsphere" {
#выносим переменные в другой файл tfvars
vsphere_server = var.vsphere_server
user = var.vsphere_user
password = var.vsphere_password
#нужно для самоподписанного сертификата
allow_unverified_ssl = "true"
}
#используемый модель от провайдера
module "vm" {
#поехали
source  = "Terraform-VMWare-Modules/vm/vsphere"
version = "3.0.0"
#имя темплейта на датацентре
vmtemp = "OracleLinux8_64"
#кол-во создаваемых виртуалок
instances = "2"
#имя/хостнеймы и суффикс виртуалок
vmname        = "test-VM-name-"
vmnameformat = "%01d"
#имя кластера в датацентре + ресурс пул (которого у нас нет, по умолчанию /Resources)
vmrp  = "Prod Esxi Cluster/Resources"
#сеть- если несколько ВМ то через запятую
network = {
  "VLAN 1290" = ["192.168.0.10", "192.168.0.11", "192.168.0.12", "192.168.0.13"]
}
  vmgateway         = ""192.168.0.1""
  ipv4submask            = ["24"]
  network_type    = ["e1000"]
#имя нашего датацентра
dc        = "Company MO DC"
#выбираем конкретный датастор где создавать ВМ
datastore = "hp-storage"
timeout = "30"
#коммент к ВМ
annotation = " test server / via terraform"
#общее кол-во CPU*CORES, например 2 цпу по 2 кора = 4
cpu_number             = "4"
#коры на каждый цпу
num_cores_per_socket  = "2"
#рам в мегабайтах
ram_size               = "4000"
#примочки
cpu_hot_add_enabled    = "true"
cpu_hot_remove_enabled = "true"
memory_hot_add_enabled = "true"
domain               = "local.lan"
dns_server_list = [""192.168.0.100"", ""192.168.0.101""]
wait_for_guest_ip_timeout = "10"
#размер диска: минимум с размером в темплейте, можно больше,
#если поддерживается ВМ то диск будет extend автоматически
disk_size_gb = ["100"]
}
