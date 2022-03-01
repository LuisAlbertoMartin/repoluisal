output "private_ip_address" {
  description = "The private ip addresses of the virtual machines"
  value       = azurerm_network_interface.vm.*.private_ip_address
}

output "linux_virtual_machine_name" {
  description = "The name of the the virtual machines"
  value       = azurerm_linux_virtual_machine.vm.*.name
}

output "linux_virtual_machine_id" {
  description = "The id of the the virtual machines"
  value       = azurerm_linux_virtual_machine.vm.*.id
}

output "public_ip_address" {
  description = "The public ip released"
  value       = azurerm_public_ip.vm.*.ip_address
}
/*
#TOFIX
output "azuread_users_objects_ids" {
  description = "The object ids of the users to the iam role assignment"
  value       = data.azuread_users.users.*.object_ids
}
*/ 