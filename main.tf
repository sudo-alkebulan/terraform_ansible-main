variable "location" {
  default = "canadacentral"
}

variable "humber_id" {
  default = "7497"
}

variable "admin_username" {
  default = "n01687497"
}

variable "admin_password" {
  type      = string
  default   = "n01687497@Humber!"
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
  default   = "ComplexP@ssw0rd123!"
}

module "common_services_7497" {
  source              = "./modules/common-7497"
  humber_id           = var.humber_id
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  log_retention_days  = 30
}

locals {
  storage_account_blob_endpoint = module.common_services_7497.storage_account_blob_endpoint
}

module "datadisk_7497" {
  source              = "./modules/datadisk-7497"
  humber_id           = var.humber_id
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  vm_ids = {
    0 = module.vmlinux_7497.vm1_id,
    1 = module.vmlinux_7497.vm2_id,
    2 = module.vmlinux_7497.vm3_id,
  }
}

module "loadbalancer_7497" {
  source              = "./modules/loadbalancer-7497"
  humber_id           = var.humber_id
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  vm_nics = {
    vm1 = module.vmlinux_7497.vm1_nic_id,
    vm2 = module.vmlinux_7497.vm2_nic_id,
    vm3 = module.vmlinux_7497.vm3_nic_id
  }
}

module "database_7497" {
  source                        = "./modules/database-7497"
  humber_id                     = var.humber_id
  location                      = var.location
  resource_group_name           = module.resource_group.resource_group_name
  admin_username                = var.admin_username
  admin_password                = var.db_password
  storage_mb                    = 5120
  backup_retention_days         = 7
  auto_grow_enabled             = true
  public_network_access_enabled = true
}

module "network_7497" {
  source              = "./modules/network-7497"
  address_space       = ["10.0.0.0/16"]
  address_prefixes    = ["10.0.0.0/24"]
  humber_id           = var.humber_id
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
}

module "resource_group" {
  source              = "./modules/rgroup-7497"
  admin_username      = var.admin_username
  private_key         = file("~/.ssh/id_rsa")
  humber_id           = var.humber_id
  location            = var.location
  resource_group_name = "RG"
}

module "vmlinux_7497" {
  source                        = "./modules/vmlinux-7497"
  humber_id                     = var.humber_id
  location                      = var.location
  resource_group_name           = module.resource_group.resource_group_name
  admin_username                = var.admin_username
  public_key                    = file("~/.ssh/id_rsa.pub")
  subnet_id                     = module.network_7497.subnet_id
  private_key                   = file("~/.ssh/id_rsa")
  vm_count                      = 3
  storage_account_blob_endpoint = local.storage_account_blob_endpoint
}

resource "local_file" "vm_html_files" {
  for_each = module.vmlinux_7497.vm_fqdns

  content  = <<EOT
<html>
  <body>
    <p>FQDN: ${each.value}</p>
  </body>
</html>
EOT

  filename = "${path.root}/project/roles/webserver-n01687497/files/${each.key}.html"
}
