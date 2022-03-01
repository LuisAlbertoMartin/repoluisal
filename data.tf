data "azurerm_monitor_action_group" "project" {
  count               = var.action_group_creation_enabled ? 0 : 1
  resource_group_name = var.action_group_existing_resource_group_name
  name                = var.action_group_existing_name
}

data "azuread_users" "users" {
  count                = var.vm_iam_role_enabled ? length(var.vm_iam_principal_id_list) : 0
  user_principal_names = [element(var.vm_iam_principal_id_list, count.index)]
}

data "azurerm_backup_policy_vm" "policy" {
  count               = var.backup_policy_vm_enabled ? 1 : 0
  name                = var.backup_policy_vm_name
  recovery_vault_name = var.backup_recovery_vault_name
  resource_group_name = var.backup_recovery_vault_resource_group_name
}
