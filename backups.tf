# Note: to delete (when "soft deleted" is enable on recovery vault service) => terraform state rm module.vm-linux.azurerm_backup_protected_vm.vm
# Into pipeline, previous task before deleting: for backup in `terraform state list |grep module.vm-linux.azurerm_backup_protected_vm.vm`; do echo deleting backup $backup; terraform state rm $backup; done
resource "azurerm_backup_protected_vm" "vm" {
  count               = var.backup_policy_vm_enabled ? var.instance_count : 0
  resource_group_name = var.backup_recovery_vault_resource_group_name
  recovery_vault_name = var.backup_recovery_vault_name
  source_vm_id        = element(azurerm_linux_virtual_machine.vm.*.id, count.index)
  backup_policy_id    = data.azurerm_backup_policy_vm.policy[0].id

  depends_on = [azurerm_linux_virtual_machine.vm]
}
