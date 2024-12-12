output "log_analytics_workspace_name" {
  value = module.common_services_7497.log_analytics_workspace_name
}

output "recovery_vault_name" {
  value = module.common_services_7497.recovery_vault_name
}

output "storage_account_name" {
  value = module.common_services_7497.storage_account_name
}

output "database_name" {
  value = module.database_7497.db
}

output "load_balancer_name" {
  value = module.loadbalancer_7497.load_balancer_name
}

output "networking_rg" {
  value = module.resource_group.resource_group_name
}

output "linux_vm_hostnames" {
  value = module.vmlinux_7497.vm_hostnames
}


output "vm_fqdns" {
  value = module.vmlinux_7497.vm_fqdns
}

output "vm_private_ip" {
  value = module.vmlinux_7497.vm_private_ip
}
output "vm_public_ip" {
  value = module.vmlinux_7497.vm_public_ip
}


output "subnet_name" {
  value = module.network_7497.subnet_name
}

output "subnet_id" {
  value = module.network_7497.subnet_id
}

output "virtual_network_name" {
  value = module.network_7497.virtual_network_name
}
output "load_balancer_fqdn" {
  value = module.loadbalancer_7497.load_balancer_fqdn
}